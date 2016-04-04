import Foundation
import Moya

enum GithubApi {
    case Repositories(String, String, Int)
    case PullRequests(String, String, Int)
}

extension GithubApi: TargetType {
    var baseURL: NSURL { return NSURL(string: "https://api.github.com")! }
    
    var path: String {
        switch self {
        case .Repositories(_, _, _):
            return "/search/repositories"
        case .PullRequests(let repository, let owner, _):
            return "/repos/\(owner)/\(repository)/pulls"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .Repositories(_, _, _), .PullRequests(_, _, _):
            return .GET
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case .Repositories(let language, let sort, let page):
            return ["q": "language:\(language)", "sort": sort, "page": page]
        case .PullRequests(_, _, let page):
            return ["page": page]
        }
    }

    var sampleData: NSData {
        return NSData()
    }
}

func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}