import UIKit
import RxSwift

protocol PullRequestsInteractorInput {
    func fetchPullRequests(request: PullRequestsRequest)
    
    var repository: Repository! { get set }
    var pullRequests: [PullRequest]? { get }
}

protocol PullRequestsInteractorOutput {
    func presentPullRequests(response: PullRequestsResponse)
    func presentPullRequestsWhenError(response: PullRequestsResponse)
}

class PullRequestsInteractor: PullRequestsInteractorInput {
    var output: PullRequestsInteractorOutput!
    var worker: PullRequestsWorker!
    
    var repository: Repository!
    var pullRequests: [PullRequest]?
    
    lazy var disposeBag = DisposeBag()
    
    // MARK: Business logic
    func fetchPullRequests(request: PullRequestsRequest) {
        self.worker = PullRequestsWorker()
        self.worker.fetchPullRequests(withRepository: self.repository.name, andOwner: self.repository.owner.login, andPage: request.page)
            .subscribe { (event) in self.handleFetchPullRequets(event) }
            .addDisposableTo(self.disposeBag)
    }
    
    private func handleFetchPullRequets(event: Event<[PullRequest]>) {
        switch event {
        case .Next(let prs):
            self.handleSuccess(prs)
        case .Error(let err):
            self.handleError(err)
        case .Completed: break
        }
    }
    
    private func handleSuccess(pullRequests: [PullRequest]) {
        self.pullRequests = pullRequests
        
        let response = PullRequestsResponse(pullRequests: pullRequests, error: nil)
        self.output.presentPullRequests(response)
    }
    
    private func handleError(error: ErrorType) {
        guard let apiError = error as? ApiError else { return }
        
        switch apiError {
        case .FailureRequest(_, let errorSummary):
            guard let error = errorSummary else { return }
            let resumeErrors = self.formatError(error)
            let response = PullRequestsResponse(pullRequests: nil, error: PullRequestsError.WrongSearch(message: error.message, detail: resumeErrors))
            self.output.presentPullRequestsWhenError(response)
        default: break
        }
    }
    
    private func formatError(errorSummary: ErrorSummary) -> String {
        var resume = ""
        for index in 0...errorSummary.errors.count-1 {
            let err = errorSummary.errors[index]
            if index == 0 {
                resume = "resource: \(err.resource), field: \(err.field), code: \(err.code)"
            } else {
                resume.appendContentsOf("\nresource: \(err.resource), field: \(err.field), code: \(err.code)")
            }
        }
        
        return resume
    }
}

