import UIKit

protocol RepositoriesPresenterInput {
    func presentSearchResult(_ response: RepositoriesResponse)
    func presentResultWhenError(_ response: RepositoriesResponse)
}

protocol RepositoriesPresenterOutput: class {
    func displaySearchResult(_ viewModel: RepositoriesViewModel)
    func displayResultWhenError(_ viewModel: RepositoriesViewModel)
}

class RepositoriesPresenter: RepositoriesPresenterInput {
    weak var output: RepositoriesPresenterOutput!
    
    // MARK: Presentation logic
    func presentSearchResult(_ response: RepositoriesResponse) {
        let repositories = response.repositories?.map { (repo) -> RepositoriesViewModel.Repository in
            return RepositoriesViewModel.Repository(
                id: "\(repo.id)",
                name: repo.name,
                fullname: repo.fullname,
                description: repo.description,
                countStars: "\(repo.starts)",
                countForks: "\(repo.forks)",
                ownerUsername: repo.owner.login,
                ownerFullname: "",
                ownerAvatarUrl: repo.owner.avatarUrl)
        }
        let viewModel = RepositoriesViewModel(repositories: repositories, error: nil)
        self.output.displaySearchResult(viewModel)
    }
    
    func presentResultWhenError(_ response: RepositoriesResponse) {
        var error = ""
        switch response.error {
        case .wrongSearch(let message, let detail)?:
            error = "\(message)\n\(detail)"
        default:
            break
        }
        
        let viewModel = RepositoriesViewModel(repositories: nil, error: error)
        self.output.displayResultWhenError(viewModel)
    }
}
