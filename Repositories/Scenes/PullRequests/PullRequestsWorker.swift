import UIKit
import RxSwift

class PullRequestsWorker {
    // MARK: Business Logic
    func fetchPullRequests(withRepository repo: String, andOwner owner: String, andPage page: Int) -> Observable<[PullRequest]> {
        return PullRequestsApi.fetchPullRequests(repo, owner: owner, page: page)
    }
}
