//
//  KarutaApiClient.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class KarutaApiClient {
    
    class Session {
        var alamofireRequest: Request? = nil
        init(_ request: Request) {
            alamofireRequest = request
        }
    }
    
    static var manager = Alamofire.Manager(configuration: KarutaApiClient.configuration)
    static let kTimeoutSecond = 10.0
    
    private static var configuration : NSURLSessionConfiguration {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = KarutaApiClient.kTimeoutSecond
        configuration.timeoutIntervalForResource = KarutaApiClient.kTimeoutSecond
        return configuration
    }
    
    private init(){}
    
    private class func APIURL<T: KarutaApiRequest>(request: T) -> String {
        return Const.API_BASE_PATH + request.endpoint
    }
    
    class func send<T: KarutaApiRequest, U where U: Mappable, U: KarutaApiResponse>(request: T, handler: (KarutaResult<U, KarutaApiClientError>) -> () = {r in} ) -> Session {
        let url = APIURL(request)
        
        // ヘッダパラメータのセット
        var headers: [String:String]? = nil
        for (key, value) in request.headerParams {
            if var headers = headers {
                headers[key] = value
            } else {
                headers = [key:value]
            }
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
                let response: KarutaResult<U, KarutaApiClientError> = KarutaApiClient.mappingResponse(httpRequest, response: httpResponse, data: data, error: error)
                
                switch response {
                case .Success(let result):
                    handler(KarutaResult<U, KarutaApiClientError>.Success(result))
                case .Failure(let error):
                    handler(KarutaResult<U, KarutaApiClientError>(error: error))
                }
        }
        return Session(alamofireRequest)
    }
    
    class func cancel(session: Session) {
        session.alamofireRequest?.cancel()
    }
    
    private class func mappingResponse<T where T: Mappable, T: KarutaApiResponse>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> KarutaResult<T, KarutaApiClientError> {
        if let error = error {
            // AlamofireのエラーかつStatusCodeValidationFailed以外の場合は一律APIのタイムアウトに丸める
            if error.domain != Error.Domain || error.code != Error.Code.StatusCodeValidationFailed.rawValue {
                return KarutaResult.Failure(KarutaApiClientError(type: .Timeout))
            }
        }
        
        guard let validData: NSData = data else {
            return KarutaResult.Failure(KarutaApiClientError(type: .NoResult))
        }
        
        var JSON: NSDictionary?
        do {
            JSON = try NSJSONSerialization.JSONObjectWithData(validData, options: .AllowFragments) as? NSDictionary
        } catch {
            return .Failure(KarutaApiClientError(type: .JsonParse))
        }
        
        guard let _ = JSON else {
            return .Failure(KarutaApiClientError(type: .JsonParse))
        }
        
        if let parsedObject = Mapper<T>().map(JSON){
            if error == nil {
                return .Success(parsedObject)
            } else {
                // AlamofireのエラーかつStatusCodeValidationFailedの場合はエラーCodeに基づいたKarutaApiClientErrorTypeを設定する
                let errorType = KarutaApiClientError(code: response?.statusCode, response: parsedObject)
                return .Failure(errorType)
            }
        } else {
            return .Failure(KarutaApiClientError(type: .Mapping))
        }
    }
}
