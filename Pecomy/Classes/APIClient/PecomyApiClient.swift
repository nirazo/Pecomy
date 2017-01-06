//
//  PecomyApiClient.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class PecomyApiClient {
    
    class Session {
        var alamofireRequest: Request? = nil
        init(_ request: Request) {
            alamofireRequest = request
        }
    }
    
    static var manager = Alamofire.SessionManager(configuration: PecomyApiClient.configuration)
    static let loginHeaderKey = "Authorization"
    static let kTimeoutSecond = 10.0
    
    fileprivate static var configuration : URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = PecomyApiClient.kTimeoutSecond
        configuration.timeoutIntervalForResource = PecomyApiClient.kTimeoutSecond
        return configuration
    }
    
    private init(){}
    
    private class func APIURL<T: PecomyApiRequest>(request: T) -> String {
        return Const.API_BASE_PATH + request.endpoint
    }
    
    class func send<T: PecomyApiRequest, U>(_ request: T, handler: @escaping (PecomyResult<U, PecomyApiClientError>) -> () = {r in} ) -> Session where U: Mappable, U: PecomyApiResponse {
        let url = APIURL(request: request)
        
        // ヘッダパラメータのセット
        var headers = [String: String]()
        if let token = KeychainManager.getPecomyUserToken() {
            headers[self.loginHeaderKey] = "Bearer \(token)"
        }
        for (key, value) in request.headerParams {
            headers[key] = value
        }
        
        let alamofireRequest = manager.request(url, method: request.method, parameters: request.params, encoding: request.encoding, headers: headers)
            .validate()
            .response {(alamoResponse) in
//                print("apiclientParams: \(request.params)")
                if let _ = alamoResponse.request, let _ = alamoResponse.response {
                    do {
                        let options = JSONSerialization.WritingOptions()
                        _ = try JSONSerialization.data(withJSONObject: request.params, options: options)
                    } catch {
                        //nothing
                    }
                }
                let response: PecomyResult<U, PecomyApiClientError> = PecomyApiClient.mappingResponse(request: alamoResponse.request, response: alamoResponse.response, data: alamoResponse.data, error: alamoResponse.error)
//                let str = String(data: alamoResponse.data!, encoding: .utf8) //NSString(data: data!, encoding:NSUTF8StringEncoding)
//                print("requestURL: \(String(describing: alamoResponse.request))")
//                print("requestParams: \(request.params)")
//                print("rawData: \(str)")
                switch response {
                case .success(let result):
                    handler(PecomyResult<U, PecomyApiClientError>.success(result))
                case .failure(let error):
                    if (error.type == PecomyApiClientErrorType.unauthorized) {
                        KeychainManager.removePecomyUserToken()
                    }
                    handler(PecomyResult<U, PecomyApiClientError>(error: error))
                }
        }
        return Session(alamofireRequest)
    }
    
    class func cancel(_ session: Session) {
        session.alamofireRequest?.cancel()
    }
    
    private class func mappingResponse<T>(request: URLRequest?, response: HTTPURLResponse?, data: Data?, error: Error?) -> PecomyResult<T, PecomyApiClientError> where T: Mappable, T: PecomyApiResponse {
        
        guard let validData = data else {
            return PecomyResult.failure(PecomyApiClientError(type: .noResult))
        }
        
        var JSON: NSDictionary?
        do {
            JSON = try JSONSerialization.jsonObject(with: validData as Data, options: .allowFragments) as? NSDictionary
            if JSON == nil {
                JSON = NSDictionary()
            }
        } catch {
            return .failure(PecomyApiClientError(type: .jsonParse))
        }
        
        guard let _ = JSON else {
            return .failure(PecomyApiClientError(type: .jsonParse))
        }
        if let parsedObject = Mapper<T>().map(JSON: JSON as! [String : Any]){
            if error == nil {
                return .success(parsedObject)
            } else {
                // AlamofireのエラーかつStatusCodeValidationFailedの場合はエラーCodeに基づいたPecomyApiClientErrorTypeを設定する
                let errorType = PecomyApiClientError(code: response?.statusCode, response: parsedObject)
                return .failure(errorType)
            }
        } else {
            return .failure(PecomyApiClientError(type: .mapping))
        }
    }
}
