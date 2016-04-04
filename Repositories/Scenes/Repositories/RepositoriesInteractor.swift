import UIKit
import RxSwift

protocol RepositoriesInteractorInput {
    func searchRepositories(withRequest request: RepositoriesRequest)
    var repositories: [Repository]? { get }
}

protocol RepositoriesInteractorOutput {
    func presentSearchResult(response: RepositoriesResponse)
    func presentResultWhenError(response: RepositoriesResponse)
}

class RepositoriesInteractor: RepositoriesInteractorInput {
    var output: RepositoriesInteractorOutput!
    var worker: RepositoriesWorker!
    var repositories: [Repository]?
    
    lazy var disposeBag = DisposeBag()
    
    // MARK: Business logic
    func searchRepositories(withRequest request: RepositoriesRequest) {
        self.worker = RepositoriesWorker()
        self.worker.searchRepositories(withLanguage: request.language, andSort: request.sort.rawValue, andPage: request.page)
            .subscribe { (event) in self.handleSearchRepositories(event) }
            .addDisposableTo(self.disposeBag)
    }
    
    private func handleSearchRepositories(event: Event<RepositoriesSummary>) {
        switch event {
        case .Next(let summary):
            self.handleSuccess(summary)
        case .Error(let err):
            self.handleError(err)
        case .Completed: break
        }
    }
    
    private func handleSuccess(summary: RepositoriesSummary) {
        self.repositories = summary.repositories
        
        let response = RepositoriesResponse(repositories: summary.repositories, error: nil)
        self.output.presentSearchResult(response)
    }
    
    private func handleError(error: ErrorType) {
        guard let apiError = error as? ApiError else { return }
        
        switch apiError {
        case .FailureRequest(_, let errorSummary):
            guard let error = errorSummary else { return }
            let resumeErrors = self.formatError(error)
            let response = RepositoriesResponse(repositories: nil, error: RepositoriesSearchError.WrongSearch(message: error.message, detail: resumeErrors))
            self.output.presentResultWhenError(response)
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
