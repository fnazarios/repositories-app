import Foundation
import Moya
import RxSwift
import Argo

func endpointsClosure() -> (GithubApi) -> Endpoint<GithubApi> {
    return { (target: GithubApi) -> Endpoint<GithubApi> in
        let parameterEncoding: Moya.ParameterEncoding = (target.method == .POST) ? .JSON : .URL
        print("[\(target.method)] \(url(target))")
        print("[Params] \(target.parameters)")
        return Endpoint<GithubApi>(URL: url(target), sampleResponseClosure: { () -> EndpointSampleResponse in
            return EndpointSampleResponse.NetworkResponse(200, target.sampleData)
        }, method: target.method, parameters: target.parameters, parameterEncoding: parameterEncoding)
    }
}

enum ApiError: ErrorType {
    case UnknownError()
    case FailureRequest(Int, ErrorSummary?)
    case FailureMapToDomain(ErrorType?)
    case FailureMapToJson()
}

extension ObservableType where E: Response {
    
    func successfulStatusCodes() -> Observable<E> {
        return statusCodes(200...299)
    }
    
    func statusCodes(range: ClosedInterval<Int>) -> Observable<E> {
        return flatMap { response -> Observable<E> in
            guard range.contains(response.statusCode) else {
                
                let json = try? NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                if let j = json {
                    let apiError: ErrorSummary? = decode(j)
                    throw ApiError.FailureRequest(response.statusCode, apiError)
                }
                
                throw ApiError.FailureRequest(response.statusCode, nil)
            }
            
            return Observable.just(response)
        }
    }
    
    func mapToDomain<T: Decodable where T == T.DecodedType>() -> Observable<T> {
        return map { response -> T in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                let decoded: Decoded<T> = decode(json)
                return try self.assertDecoded(decoded, json: json)
            } catch {
                throw error
            }
        }
    }
    
    func mapArrayToDomain<T: Decodable where T == T.DecodedType>() -> Observable<[T]> {
        return map { response -> [T] in
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: .AllowFragments)
                let decoded: Decoded<[T]> = decode(json)
                return try self.assertDecoded(decoded, json: json)
            } catch {
                throw error
            }
        }
    }
    
    func assertDecoded<T>(decoded: Decoded<T>, json: AnyObject) throws -> T {
        switch decoded {
        case .Success(let value):
            return value
        case .Failure(let err):
            throw ApiError.FailureMapToDomain(err)
        }
    }
}
