import UIKit
import RxSwift

protocol PullRequestsInteractorInput {
    func fetchPullRequests(_ request: PullRequestsRequest)
    
    var repository: Repository! { get set }
    var pullRequests: [PullRequest]? { get }
}

protocol PullRequestsInteractorOutput {
    func presentPullRequests(_ response: PullRequestsResponse)
    func presentPullRequestsWhenError(_ response: PullRequestsResponse)
}

class PullRequestsInteractor: PullRequestsInteractorInput {
    var output: PullRequestsInteractorOutput!
    var worker: PullRequestsWorker!
    
    var repository: Repository!
    var pullRequests: [PullRequest]?
    
    lazy var disposeBag = DisposeBag()
    
    // MARK: Business logic
    func fetchPullRequests(_ request: PullRequestsRequest) {
        self.worker = PullRequestsWorker()
        self.worker.fetchPullRequests(withRepository: self.repository.name, andOwner: self.repository.owner.login, andPage: request.page)
            .subscribe { (event) in self.handleFetchPullRequets(event) }
            .addDisposableTo(self.disposeBag)
    }
    
    fileprivate func handleFetchPullRequets(_ event: Event<[PullRequest]>) {
        switch event {
        case .next(let prs):
            self.handleSuccess(prs)
        case .error(let err):
            self.handleError(err)
        case .completed: break
        }
    }
    
    fileprivate func handleSuccess(_ pullRequests: [PullRequest]) {
        self.pullRequests = pullRequests
        
        let response = PullRequestsResponse(pullRequests: self.pullRequests, error: nil)
        self.output.presentPullRequests(response)
    }
    
    fileprivate func handleError(_ error: Swift.Error) {
        guard let apiError = error as? ApiError else { return }
        
        switch apiError {
        case .failureRequest(_, let errorSummary):
            guard let error = errorSummary else { return }
            let resumeErrors = self.formatError(error)
            let response = PullRequestsResponse(pullRequests: nil, error: PullRequestsError.wrongSearch(message: error.message, detail: resumeErrors))
            self.output.presentPullRequestsWhenError(response)
        default: break
        }
    }
    
    fileprivate func formatError(_ errorSummary: ErrorSummary) -> String {
        var resume = ""
        for index in 0...errorSummary.errors.count-1 {
            let err = errorSummary.errors[index]
            if index == 0 {
                resume = "resource: \(err.resource), field: \(err.field), code: \(err.code)"
            } else {
                resume.append("\nresource: \(err.resource), field: \(err.field), code: \(err.code)")
            }
        }
        
        return resume
    }
}

