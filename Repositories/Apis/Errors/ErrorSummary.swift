import Foundation
import Argo
import Curry
import Runes

struct Error {
    let resource: String
    let field: String
    let code: String
}

struct ErrorSummary {
    let message: String
    let errors: [Error]
}

extension Error: Decodable {
    static func decode(_ j: JSON) -> Decoded<Error> {
        return curry(Error.init)
            <^> j <| "resource"
            <*> j <| "field"
            <*> j <| "code"
    }
}

extension ErrorSummary: Decodable {
    static func decode(_ j: JSON) -> Decoded<ErrorSummary> {
        return curry(ErrorSummary.init)
            <^> j <| "message"
            <*> j <|| "errors"
    }
}
