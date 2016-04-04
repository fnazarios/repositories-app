import UIKit
import BRYXBanner

protocol RepositoriesViewControllerInput {
    func displaySearchResult(viewModel: RepositoriesViewModel)
    func displayResultWhenError(viewModel: RepositoriesViewModel)
}

protocol RepositoriesViewControllerOutput {
    func searchRepositories(withRequest request: RepositoriesRequest)
    var repositories: [Repository]? { get }
}

class RepositoriesViewController: DefaultListViewController, RepositoriesViewControllerInput {
    
    @IBOutlet weak var repositoriesTableView: UITableView!
    
    var output: RepositoriesViewControllerOutput!
    var router: RepositoriesRouter!
    
    var tableViewData: [RepositoriesViewModel.Repository] = []
    var page = 0
    
    // MARK: Object lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        RepositoriesConfigurator.sharedInstance.configure(self)
    }
    
    func configureRefreshControl() {
        self.refreshControl.configure(inView: self.repositoriesTableView, target: self, action: #selector(self.refresh))
    }
    
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("Repositories", comment: "")
        self.configureRefreshControl()
        self.refresh()
    }
    
    // MARK: Event handling
    func refresh() {
        self.page = 0
        self.startLoading()
        self.fetchRepositories(withPage: self.page)
    }
    
    func fetchRepositories(withPage page: Int) {
        let request = RepositoriesRequest(withLanguage: "Java", sort: .Star, page: page)
        self.output.searchRepositories(withRequest: request)
    }
    
    func showErrorNotification(errorInfo: String?) {
        let banner = Banner(title: NSLocalizedString("Something unusual happened 😁😔", comment: ""), subtitle: errorInfo, image: nil, backgroundColor: UIColor.redColor(), didTapBlock: nil)
        banner.show(duration: 10.0)
    }
}

extension RepositoriesViewController: RepositoriesPresenterOutput {
    // MARK: Display logic
    func displaySearchResult(viewModel: RepositoriesViewModel) {
        self.endLoading()
        self.reloadTableViewAnimated(viewModel.repositories)
    }
    
    func displayResultWhenError(viewModel: RepositoriesViewModel) {
        self.endLoading()
        self.showErrorNotification(viewModel.error)
    }
    
    func reloadTableViewAnimated(repositories: [RepositoriesViewModel.Repository]?) {
        guard let repos = repositories else { return }
        
        self.clearTableViewIfNeed()
        
        var pathsReload: [NSIndexPath] = []
        var pathsInsert: [NSIndexPath] = []
        for repo in repos {
            if self.tableViewData.contains({ $0.id == repo.id }) {
                let indexFound = self.tableViewData.indexOf({ $0.id == repo.id })
                self.tableViewData.removeAtIndex(indexFound!)
                self.tableViewData.insert(repo, atIndex: indexFound!)
                
                pathsReload.append(NSIndexPath(forRow: indexFound!, inSection: 0))
            } else {
                self.tableViewData.append(repo)
                pathsInsert.append(NSIndexPath(forRow: self.tableViewData.count-1, inSection: 0))
            }
        }
        
        self.repositoriesTableView.insertRowsAtIndexPaths(pathsInsert, withRowAnimation: .Fade)
        self.repositoriesTableView.reloadRowsAtIndexPaths(pathsReload, withRowAnimation: .Fade)
    }
    
    func clearTableViewIfNeed() {
        if self.page == 0 && self.tableViewData.count > 0 {
            self.tableViewData = []
            self.repositoriesTableView.reloadData()
        }
    }
}

extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryCell") as! RepositoryCell
        
        let repo = self.tableViewData[indexPath.row]
        
        cell.configure(repo)
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == (self.tableViewData.count - 1) {
            self.page += 1
            self.fetchRepositories(withPage: self.page)
        }
    }
}
