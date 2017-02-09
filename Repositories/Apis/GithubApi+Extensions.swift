import Foundation
import Moya
import RxSwift
import Argo

func endpointsClosure() -> (GithubApi) -> Endpoint<GithubApi> {
    return { (target: GithubApi) -> Endpoint<GithubApi> in
        let parameterEncoding: Moya.ParameterEncoding = (target.method == .post) ? JSONEncoding() : URLEncoding()
        print("[\(target.method)] \(url(target))")
        print("[Params] \(target.parameters)")
        return Endpoint<GithubApi>(url: url(target), sampleResponseClosure: { () -> EndpointSampleResponse in
            return EndpointSampleResponse.networkResponse(200, target.sampleData)
        }, method: target.method, parameters: target.parameters, parameterEncoding: parameterEncoding)
    }
}

enum ApiError: Swift.Error {
    case unknownError()
    case failureRequest(Int, ErrorSummary?)
    case failureMapToDomain(Swift.Error?)
    case failureMapToJson()
}

extension ObservableType where E: Response {
    
    func successfulStatusCodes() -> Observable<E> {
        return statusCodes(200...299)
    }
    
    func statusCodes(_ range: ClosedRange<Int>) -> Observable<E> {
        return flatMap { response -> Observable<E> in

            print("\(response.statusCode) [\(response.request?.httpMethod ?? "")] \(response.request?.url?.absoluteString ?? "")")
//            let body = NSString(data: response.data, encoding: String.Encoding.utf8.rawValue) as! String
//            print("[Body] \(body)")
            
            guard range.contains(response.statusCode) else {
                
                let json = try? JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                if let j = json {
                    let apiError: ErrorSummary? = decode(j)
                    throw ApiError.failureRequest(response.statusCode, apiError)
                }
                
                throw ApiError.failureRequest(response.statusCode, nil)
            }
            
            return Observable.just(response)
        }
    }
    
    func mapToDomain<T: Decodable>() -> Observable<T> where T == T.DecodedType {
        return map { response -> T in
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                let decoded: Decoded<T> = decode(json)
                return try self.assertDecoded(decoded, json: json as AnyObject)
            } catch {
                throw error
            }
        }
    }
    
    func mapArrayToDomain<T: Decodable>() -> Observable<[T]> where T == T.DecodedType {
        return map { response -> [T] in
            do {
                let json = try JSONSerialization.jsonObject(with: response.data, options: .allowFragments)
                let decoded: Decoded<[T]> = decode(json)
                return try self.assertDecoded(decoded, json: json as AnyObject)
            } catch {
                throw error
            }
        }
    }
    
    func assertDecoded<T>(_ decoded: Decoded<T>, json: AnyObject) throws -> T {
        switch decoded {
        case .success(let value):
            return value
        case .failure(let err):
            throw ApiError.failureMapToDomain(err)
        }
    }
}
