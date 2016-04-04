import UIKit

enum PullRequestsError: ErrorType {
    case WrongSearch(message: String, detail: String)
}

struct PullRequestsRequest {
    var page: Int = 0
}

struct PullRequestsResponse {
    var pullRequests: [PullRequest]?
    var error: PullRequestsError?
}

struct PullRequestsViewModel {
    struct PullRequest {
        let id: String
        let title: String
        let body: String
        let createdAt: String?
        let url: String
        let userAvatarUrl: String
        let userUsername: String
        let userFullname: String
    }
    
    let pullRequests: [PullRequestsViewModel.PullRequest]?
    let error: String?
}
