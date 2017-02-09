import UIKit

enum RepositoriesSearchError: Swift.Error {
    case wrongSearch(message: String, detail: String)
}

enum Sort: String {
    case Star = "star"
}

struct RepositoriesRequest {
    var language: String = ""
    var sort: Sort = Sort.Star
    var page: Int = 0
    
    init(withLanguage language: String, sort: Sort, page: Int) {
        self.language = language
        self.sort = sort
        self.page = page
    }
    
    init(withLanguage language: String) {
        self.init(withLanguage: language, sort: Sort.Star, page: 0)
    }
}

struct RepositoriesResponse {
    var repositories: [Repository]?
    var error: RepositoriesSearchError?
}

struct RepositoriesViewModel {
    struct Repository {
        let id: String
        let name: String
        let fullname: String
        let description: String
        let countStars: String
        let countForks: String
        let ownerUsername: String
        let ownerFullname: String
        let ownerAvatarUrl: String
    }
    
    let repositories: [Repository]?
    let error: String?
}
