import UIKit
import RxSwift

protocol RepositoriesInteractorInput {
    func searchRepositories(withRequest request: RepositoriesRequest)
    var repositories: [Repository]? { get }
}

protocol RepositoriesInteractorOutput {
    func presentSearchResult(_ response: RepositoriesResponse)
    func presentResultWhenError(_ response: RepositoriesResponse)
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
    
    fileprivate func handleSearchRepositories(_ event: Event<RepositoriesSummary>) {
        switch event {
        case .next(let summary):
            self.handleSuccess(summary)
        case .error(let err):
            self.handleError(err)
        case .completed: break
        }
    }
    
    fileprivate func handleSuccess(_ summary: RepositoriesSummary) {
        self.repositories = summary.repositories
        
        let response = RepositoriesResponse(repositories: summary.repositories, error: nil)
        self.output.presentSearchResult(response)
    }
    
    fileprivate func handleError(_ error: Swift.Error) {
        guard let apiError = error as? ApiError else { return }
        
        switch apiError {
        case .failureRequest(_, let errorSummary):
            guard let error = errorSummary else { return }
            let resumeErrors = self.formatError(error)
            let response = RepositoriesResponse(repositories: nil, error: RepositoriesSearchError.wrongSearch(message: error.message, detail: resumeErrors))
            self.output.presentResultWhenError(response)
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
