import Foundation
import Argo
import Curry
import Runes

struct RepositoriesSummary {
    let totalCount: Int
    let repositories: [Repository]
}

extension RepositoriesSummary: Decodable {
    static func decode(_ j: JSON) -> Decoded<RepositoriesSummary> {
        return curry(RepositoriesSummary.init)
            <^> j <| "total_count"
            <*> j <|| "items"
    }
}
