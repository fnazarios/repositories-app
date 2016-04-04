import UIKit
import BRYXBanner
import SafariServices

protocol PullRequestsViewControllerInput {
    func displayPullRequests(viewModel: PullRequestsViewModel)
    func displayPullRequestsWhenError(viewModel: PullRequestsViewModel)
}

protocol PullRequestsViewControllerOutput {
    func fetchPullRequests(request: PullRequestsRequest)
    var repository: Repository! { get set }
}

class PullRequestsViewController: DefaultListViewController, PullRequestsViewControllerInput {
    
    @IBOutlet weak var pullRequestsTableView: UITableView!
    
    var output: PullRequestsViewControllerOutput!
    var router: PullRequestsRouter!
    
    var tableViewData: [PullRequestsViewModel.PullRequest] = []
    var page = 0
    
    // MARK: Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        PullRequestsConfigurator.sharedInstance.configure(self)
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.output.repository.fullname
        
        self.pullRequestsTableView.rowHeight = UITableViewAutomaticDimension
        self.pullRequestsTableView.estimatedRowHeight = 170.0
        
        self.configureRefreshControl()
        self.refresh()
    }
    
    func configureRefreshControl() {
        self.refreshControl.configure(inView: self.pullRequestsTableView, target: self, action: #selector(self.refresh))
    }
    
    // MARK: Event handling
    func refresh() {
        self.page = 0
        self.startLoading()
        self.fetchPullRequests(withPage: self.page)
    }
    
    func fetchPullRequests(withPage page: Int) {
        let request = PullRequestsRequest(page: page)
        self.output.fetchPullRequests(request)
    }
    
    // MARK: Display logic
    func displayPullRequests(viewModel: PullRequestsViewModel) {
        self.endLoading()
        self.reloadTableViewAnimated(viewModel.pullRequests)
    }
    
    func displayPullRequestsWhenError(viewModel: PullRequestsViewModel) {
        self.endLoading()
        self.showErrorNotification(viewModel.error)
    }
    
    func showErrorNotification(errorInfo: String?) {
        let banner = Banner(title: NSLocalizedString("Something unusual happened 😁😔", comment: ""), subtitle: errorInfo, image: nil, backgroundColor: UIColor.redColor(), didTapBlock: nil)
        banner.show(duration: 10.0)
    }
    
    func reloadTableViewAnimated(pullRequests: [PullRequestsViewModel.PullRequest]?) {
        guard let prs = pullRequests else { return }
        
        self.clearTableViewIfNeed()
        
        var pathsReload: [NSIndexPath] = []
        var pathsInsert: [NSIndexPath] = []
        for pullRequest in prs {
            if self.tableViewData.contains({ $0.id == pullRequest.id }) {
                let indexFound = self.tableViewData.indexOf({ $0.id == pullRequest.id })
                self.tableViewData.removeAtIndex(indexFound!)
                self.tableViewData.insert(pullRequest, atIndex: indexFound!)
                
                pathsReload.append(NSIndexPath(forRow: indexFound!, inSection: 0))
            } else {
                self.tableViewData.append(pullRequest)
                pathsInsert.append(NSIndexPath(forRow: self.tableViewData.count-1, inSection: 0))
            }
        }
        
        self.pullRequestsTableView.insertRowsAtIndexPaths(pathsInsert, withRowAnimation: .Fade)
        self.pullRequestsTableView.reloadRowsAtIndexPaths(pathsReload, withRowAnimation: .Fade)
    }
    
    func clearTableViewIfNeed() {
        if self.page == 0 && self.tableViewData.count > 0 {
            self.tableViewData = []
            self.pullRequestsTableView.reloadData()
        }
    }
    
    func openPullRequest(pullRequest: PullRequestsViewModel.PullRequest) {
        let safariViewController = SafariViewController(URL: NSURL(string: pullRequest.url)!)
        self.presentViewController(safariViewController, animated: true, completion: nil)
    }
}

extension PullRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PullRequestCell") as! PullRequestCell
        
        let pr = self.tableViewData[indexPath.row]
        
        cell.configure(pr)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (self.tableViewData.count - 1) {
            self.page += 1
            self.fetchPullRequests(withPage: self.page)
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let pr = self.tableViewData[indexPath.row]
        self.openPullRequest(pr)
    }
}
