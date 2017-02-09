import UIKit
import BRYXBanner
import SafariServices

protocol PullRequestsViewControllerInput {
    func displayPullRequests(_ viewModel: PullRequestsViewModel)
    func displayPullRequestsWhenError(_ viewModel: PullRequestsViewModel)
}

protocol PullRequestsViewControllerOutput {
    func fetchPullRequests(_ request: PullRequestsRequest)
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
    func displayPullRequests(_ viewModel: PullRequestsViewModel) {
        self.endLoading()
        self.reloadTableViewAnimated(viewModel.pullRequests)
    }
    
    func displayPullRequestsWhenError(_ viewModel: PullRequestsViewModel) {
        self.endLoading()
        self.showErrorNotification(viewModel.error)
    }
    
    func showErrorNotification(_ errorInfo: String?) {
        let banner = Banner(title: NSLocalizedString("Something unusual happened 😁😔", comment: ""), subtitle: errorInfo, image: nil, backgroundColor: UIColor.red, didTapBlock: nil)
        banner.show(duration: 10.0)
    }
    
    func reloadTableViewAnimated(_ pullRequests: [PullRequestsViewModel.PullRequest]?) {
        guard let prs = pullRequests else { return }
        
        self.clearTableViewIfNeed()
        
        var pathsReload: [IndexPath] = []
        var pathsInsert: [IndexPath] = []
        for pullRequest in prs {
            if self.tableViewData.contains(where: { $0.id == pullRequest.id }) {
                let indexFound = self.tableViewData.index(where: { $0.id == pullRequest.id })
                self.tableViewData.remove(at: indexFound!)
                self.tableViewData.insert(pullRequest, at: indexFound!)
                
                pathsReload.append(IndexPath(row: indexFound!, section: 0))
            } else {
                self.tableViewData.append(pullRequest)
                pathsInsert.append(IndexPath(row: self.tableViewData.count-1, section: 0))
            }
        }
        
        self.pullRequestsTableView.insertRows(at: pathsInsert, with: .fade)
        self.pullRequestsTableView.reloadRows(at: pathsReload, with: .fade)
    }
    
    func clearTableViewIfNeed() {
        if self.page == 0 && self.tableViewData.count > 0 {
            self.tableViewData = []
            self.pullRequestsTableView.reloadData()
        }
    }
    
    func openPullRequest(_ pullRequest: PullRequestsViewModel.PullRequest) {
        let safariViewController = SafariViewController(url: URL(string: pullRequest.url)!)
        self.present(safariViewController, animated: true, completion: nil)
    }
}

extension PullRequestsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PullRequestCell") as! PullRequestCell
        
        let pr = self.tableViewData[indexPath.row]
        
        cell.configure(pr)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.tableViewData.count - 1) {
            self.page += 1
            self.fetchPullRequests(withPage: self.page)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pr = self.tableViewData[indexPath.row]
        self.openPullRequest(pr)
    }
}
