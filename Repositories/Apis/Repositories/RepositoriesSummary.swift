import Foundation
import Argo
import Curry

struct RepositoriesSummary {
    let totalCount: Int
    let repositories: [Repository]
}

extension RepositoriesSummary: Decodable {
    static func decode(j: JSON) -> Decoded<RepositoriesSummary> {
        return curry(RepositoriesSummary.init)
            <^> j <| "total_count"
            <*> j <|| "items"
    }
}