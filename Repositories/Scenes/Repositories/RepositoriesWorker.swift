import UIKit
import RxSwift

class RepositoriesWorker {
    // MARK: Business Logic
    func searchRepositories(withLanguage lang: String, andSort sort: String, andPage page: Int) -> Observable<RepositoriesSummary> {
        return RepositoriesApi.searchRepositories(lang, sort: sort, page: page)
    }
}
