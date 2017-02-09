import Foundation
import RxSwift
import Moya

class PullRequestsApi {
    
    static var provider = RxMoyaProvider<GithubApi>(endpointClosure: endpointsClosure())
    
    class func fetchPullRequests(_ repository: String, owner: String, page: Int) -> Observable<[PullRequest]> {
        return provider.request(.pullRequests(repository, owner, page))
            .successfulStatusCodes()
            .mapArrayToDomain()
    }
}
