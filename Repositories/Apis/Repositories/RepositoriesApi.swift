import Foundation
import RxSwift
import Moya

class RepositoriesApi {
    
    static var provider = RxMoyaProvider<GithubApi>(endpointClosure: endpointsClosure())
    
    class func searchRepositories(_ language: String, sort: String, page: Int) -> Observable<RepositoriesSummary> {
        return provider.request(.repositories(language, sort, page))
            .successfulStatusCodes()
            .mapToDomain()
    }
}

