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
    
    public static var manager = Alamofire.Manager(configuration: KarutaApiClient.configuration)
    public static let kTimeoutSecond = 30.0
    
    private static var configuration : NSURLSessionConfiguration {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = Alamofire.Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = KarutaApiClient.kTimeoutSecond
        configuration.timeoutIntervalForResource = KarutaApiClient.kTimeoutSecond
        return configuration
    }
    
    private static var alamofireManager: Alamofire.Manager {
        return Alamofire.Manager(configuration: configuration)
    }
    
    private init(){}
    
    private class func APIURL<T: KarutaApiRequest>(request: T) -> String {
        return Const.API_BASE_PATH + request.endpoint
    }
    
    class func send<T: KarutaApiRequest, U where U: Mappable, U: KarutaApiResponse>(request: T, handler: (KarutaResult<U, Error>) -> () = {r in} ) -> Session {
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
                let response: KarutaResult<U, Error> = KarutaApiClient.mappingResponse(httpRequest, response: httpResponse, data: data, error: error)
                
                switch response {
                case .Success(let result):
                    handler(KarutaResult<U, Error>.Success(result))
                case .Failure(let error):
                    handler(KarutaResult<U, Error>.Failure(error))
                }
        }
        return Session(alamofireRequest)
    }
    
    public class func cancel(session: Session) {
        session.alamofireRequest?.cancel()
    }
    
    private class func mappingResponse<T where T: Mappable, T: KarutaApiResponse>(request: NSURLRequest?, response: NSHTTPURLResponse?, data: NSData?, error: NSError?) -> KarutaResult<T, Error> {
        
    }
}
