import Foundation
import Argo
import Curry

struct PullRequest {
    let id: Int
    let title: String
    let body: String
    let createdAt: NSDate
    let url: String
    let user: User
}

extension PullRequest: Decodable {
    static func decode(j: JSON) -> Decoded<PullRequest> {
        return curry(PullRequest.init)
            <^> j <| "id"
            <*> j <| "title"
            <*> j <| "body"
            <*> j <| "created_at"
            <*> j <| "html_url"
            <*> j <| "user"
    }
}