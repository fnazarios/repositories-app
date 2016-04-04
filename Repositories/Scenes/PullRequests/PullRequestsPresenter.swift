import UIKit

protocol PullRequestsPresenterInput {
    func presentPullRequests(response: PullRequestsResponse)
    func presentPullRequestsWhenError(response: PullRequestsResponse)
}

protocol PullRequestsPresenterOutput: class {
    func displayPullRequests(viewModel: PullRequestsViewModel)
    func displayPullRequestsWhenError(viewModel: PullRequestsViewModel)
}

class PullRequestsPresenter: PullRequestsPresenterInput {
    weak var output: PullRequestsPresenterOutput!
    
    // MARK: Presentation logic
    func presentPullRequests(response: PullRequestsResponse) {
        let pullRequests = response.pullRequests?.map { (pr) -> PullRequestsViewModel.PullRequest in
            return PullRequestsViewModel.PullRequest(
                id: "\(pr.id)",
                title: pr.title,
                body: pr.body.characters.count == 0 ? NSLocalizedString("No body for this pull request", comment: "") : pr.body,
                createdAt: pr.createdAt.stringFromDate("dd/MM/yyyy"),
                url: pr.url,
                userAvatarUrl: pr.user.avatarUrl,
                userUsername: pr.user.login,
                userFullname: "")
        }
        let viewModel = PullRequestsViewModel(pullRequests: pullRequests, error: nil)
        self.output.displayPullRequests(viewModel)
    }
    
    func presentPullRequestsWhenError(response: PullRequestsResponse) {
        var error = ""
        switch response.error {
        case .WrongSearch(let message, let detail)?:
            error = "\(message)\n\(detail)"
        default:
            break
        }
        
        let viewModel = PullRequestsViewModel(pullRequests: nil, error: error)
        self.output.displayPullRequestsWhenError(viewModel)
    }
}
