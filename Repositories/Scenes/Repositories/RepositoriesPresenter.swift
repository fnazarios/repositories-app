import UIKit

protocol RepositoriesPresenterInput {
    func presentSearchResult(response: RepositoriesResponse)
    func presentResultWhenError(response: RepositoriesResponse)
}

protocol RepositoriesPresenterOutput: class {
    func displaySearchResult(viewModel: RepositoriesViewModel)
    func displayResultWhenError(viewModel: RepositoriesViewModel)
}

class RepositoriesPresenter: RepositoriesPresenterInput {
    weak var output: RepositoriesPresenterOutput!
    
    // MARK: Presentation logic
    func presentSearchResult(response: RepositoriesResponse) {
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
    
    func presentResultWhenError(response: RepositoriesResponse) {
        var error = ""
        switch response.error {
        case .WrongSearch(let message, let detail)?:
            error = "\(message)\n\(detail)"
        default:
            break
        }
        
        let viewModel = RepositoriesViewModel(repositories: nil, error: error)
        self.output.displayResultWhenError(viewModel)
    }
}
