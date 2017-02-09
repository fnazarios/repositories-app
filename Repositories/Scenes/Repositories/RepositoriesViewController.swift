import UIKit
import BRYXBanner

protocol RepositoriesViewControllerInput {
    func displaySearchResult(_ viewModel: RepositoriesViewModel)
    func displayResultWhenError(_ viewModel: RepositoriesViewModel)
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
        let request = RepositoriesRequest(withLanguage: "Swift", sort: .Star, page: page)
        self.output.searchRepositories(withRequest: request)
    }
    
    func showErrorNotification(_ errorInfo: String?) {
        let banner = Banner(title: NSLocalizedString("Something unusual happened 😁😔", comment: ""), subtitle: errorInfo, image: nil, backgroundColor: UIColor.red, didTapBlock: nil)
        banner.show(duration: 10.0)
    }
}

extension RepositoriesViewController: RepositoriesPresenterOutput {
    // MARK: Display logic
    func displaySearchResult(_ viewModel: RepositoriesViewModel) {
        self.endLoading()
        self.reloadTableViewAnimated(viewModel.repositories)
    }
    
    func displayResultWhenError(_ viewModel: RepositoriesViewModel) {
        self.endLoading()
        self.showErrorNotification(viewModel.error)
    }
    
    func reloadTableViewAnimated(_ repositories: [RepositoriesViewModel.Repository]?) {
        guard let repos = repositories else { return }
        
        self.clearTableViewIfNeed()
        
        var pathsReload: [IndexPath] = []
        var pathsInsert: [IndexPath] = []
        for repo in repos {
            if self.tableViewData.contains(where: { $0.id == repo.id }) {
                let indexFound = self.tableViewData.index(where: { $0.id == repo.id })
                self.tableViewData.remove(at: indexFound!)
                self.tableViewData.insert(repo, at: indexFound!)
                
                pathsReload.append(IndexPath(row: indexFound!, section: 0))
            } else {
                self.tableViewData.append(repo)
                pathsInsert.append(IndexPath(row: self.tableViewData.count-1, section: 0))
            }
        }
        
        self.repositoriesTableView.insertRows(at: pathsInsert, with: .fade)
        self.repositoriesTableView.reloadRows(at: pathsReload, with: .fade)
    }
    
    func clearTableViewIfNeed() {
        if self.page == 0 && self.tableViewData.count > 0 {
            self.tableViewData = []
            self.repositoriesTableView.reloadData()
        }
    }
}

extension RepositoriesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryCell") as! RepositoryCell
        
        let repo = self.tableViewData[indexPath.row]
        
        cell.configure(repo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (self.tableViewData.count - 1) {
            self.page += 1
            self.fetchRepositories(withPage: self.page)
        }
    }
}
