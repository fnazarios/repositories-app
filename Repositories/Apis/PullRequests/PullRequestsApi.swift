import Foundation
import RxSwift
import Moya

class PullRequestsApi {
    
    static var provider = RxMoyaProvider<GithubApi>(endpointClosure: endpointsClosure())
    
    class func fetchPullRequests(repository: String, owner: String, page: Int) -> Observable<[PullRequest]> {
        return provider.request(.PullRequests(repository, owner, page))
            .successfulStatusCodes()
            .mapArrayToDomain()
    }
}

