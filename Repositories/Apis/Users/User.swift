import Foundation
import Argo
import Curry

struct User {
    let id: Int
    let login: String
    let avatarUrl: String
}

extension User: Decodable {
    static func decode(j: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> j <| "id"
            <*> j <| "login"
            <*> j <| "avatar_url"
    }
}