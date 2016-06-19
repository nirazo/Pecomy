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
    
    static var manager = Alamofire.Manager(configuration: PecomyApiClient.configuration)
    static let loginHeaderKey = "Authorization"
    static let kTimeoutSecond = 10.0
    
    private static var configuration : NSURLSessionConfiguration {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = PecomyApiClient.kTimeoutSecond
        configuration.timeoutIntervalForResource = PecomyApiClient.kTimeoutSecond
        return configuration
    }
    
    private init(){}
    
    private class func APIURL<T: PecomyApiRequest>(request: T) -> String {
        return Const.API_BASE_PATH + request.endpoint
    }
    
    class func send<T: PecomyApiRequest, U where U: Mappable, U: PecomyApiResponse>(request: T, handler: (PecomyResult<U, PecomyApiClientError>) -> () = {r in} ) -> Session {
        let url = APIURL(request)
        
        // ヘッダパラメータのセット
        var headers = [String: String]()
        if let token = KeychainManager.getPecomyUserToken() {
            headers[self.loginHeaderKey] = "Bearer \(token)"
        }
        for (key, value) in request.headerParams {
            headers[key] = value
        }
        
        let alamofireRequest = manager.request(request.method, url, parameters: request.params, encoding: request.encoding, headers: headers)
            .validate()
            .response {(httpRequest, httpResponse, data, error) in
                if let _ = httpRequest, _ = httpResponse {
                    do {
                        let options = NSJSONWritingOptions()
                        _ = try NSJSONSerialization.dataWithJSONObject(request.params, options: options)
                    } catch {
                        //nothing
                    }
                }
                let response: PecomyResult<U, PecomyApiClientError> = PecomyApiClient.mappingResponse(httpRequest, response: httpResponse, data: data, error: error)
                switch response {
                case .Success(let result):
                    handler(PecomyResult<U, PecomyApiClientError>.Success(result))
                case .Failure(let error):
                    handler(PecomyResult<U, PecomyApiClientError>(error: error))
                }
        }
        return Session(alamofireRequest)
    }
    
    class func cancel(session: Session) {
        session.alamofireRequest?.cancel()
    }
    
    private class func mappingResponse<T where T: Mappable, T: PecomyApiResponse>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> PecomyResult<T, PecomyApiClientError> {
        if let error = error {
            // AlamofireのエラーかつStatusCodeValidationFailed以外の場合は一律APIのタイムアウトに丸める
            if error.domain != Error.Domain || error.code != Error.Code.StatusCodeValidationFailed.rawValue {
                return PecomyResult.Failure(PecomyApiClientError(type: .Timeout))
            }
        }
                
        guard let validData: NSData = data else {
            return PecomyResult.Failure(PecomyApiClientError(type: .NoResult))
        }
        
        var JSON: NSDictionary?
        do {
            JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: .AllowFragments) as? NSDictionary
            if JSON == nil {
                JSON = NSDictionary()
            }
        } catch {
            return .Failure(PecomyApiClientError(type: .JsonParse))
        }
        
        guard let _ = JSON else {
            return .Failure(PecomyApiClientError(type: .JsonParse))
        }
        if let parsedObject = Mapper<T>().map(JSON){
            if error == nil {
                return .Success(parsedObject)
            } else {
                // AlamofireのエラーかつStatusCodeValidationFailedの場合はエラーCodeに基づいたPecomyApiClientErrorTypeを設定する
                let errorType = PecomyApiClientError(code: response?.statusCode, response: parsedObject)
                return .Failure(errorType)
            }
        } else {
            return .Failure(PecomyApiClientError(type: .Mapping))
        }
    }
}
