import Foundation
import Argo
import Curry
import Runes

struct User {
    let id: Int
    let login: String
    let avatarUrl: String
}

extension User: Decodable {
    static func decode(_ j: JSON) -> Decoded<User> {
        return curry(User.init)
            <^> j <| "id"
            <*> j <| "login"
            <*> j <| "avatar_url"
    }
}
