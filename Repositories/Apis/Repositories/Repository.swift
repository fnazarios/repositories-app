import Foundation
import Argo
import Curry

struct Repository {
    let id: Int
    let name: String
    let fullname: String
    let description: String
    let starts: Int
    let forks: Int
    let owner: User
}

extension Repository: Decodable {
    static func decode(j: JSON) -> Decoded<Repository> {
        return curry(Repository.init)
            <^> j <| "id"
            <*> j <| "name"
            <*> j <| "full_name"
            <*> j <| "description"
            <*> j <| "stargazers_count"
            <*> j <| "forks"
            <*> j <| "owner"
    }
}