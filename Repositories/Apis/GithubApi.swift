import Foundation
import Moya

enum GithubApi {
    case repositories(String, String, Int)
    case pullRequests(String, String, Int)
}

extension GithubApi: TargetType {
    var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    var task: Task {
        return .request
    }
    
    var path: String {
        switch self {
        case .repositories(_, _, _):
            return "/search/repositories"
        case .pullRequests(let repository, let owner, _):
            return "/repos/\(owner)/\(repository)/pulls"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .repositories(_, _, _), .pullRequests(_, _, _):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .repositories(let language, let sort, let page):
            return ["q": "language:\(language)" as AnyObject, "sort": sort as AnyObject, "page": page as AnyObject]
        case .pullRequests(_, _, let page):
            return ["page": page as AnyObject]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding()
    }

    var sampleData: Data {
        return Data()
    }
    
    
    var validate: Bool {
        return false
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
