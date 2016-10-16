//
//  PecomyApiClientError.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/05.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

public enum PecomyApiClientErrorType: ErrorType {
    case JsonParse
    case Mapping
    case Timeout //ネットワーク不通によるエラー
    case Cancelled //キャンセル実行時のエラー
    case Unknown //どのエラーにも該当しないエラー
    
    case InvalidID // 400
    case Unauthorized // 401
    case ServerError // 500
    case NoResult // 404
    
    init(errorCode: Int?, message: String) {
        guard let code = errorCode else {
            self = .Unknown
            return
        }
        switch code {
        case 400:
            self = .InvalidID
        case 401:
            self = .Unauthorized
        case 500:
            self = .ServerError
        case 404:
            self = .NoResult
        default:
            self = .Unknown
        }
    }
}

public struct PecomyApiClientError {
    var type = PecomyApiClientErrorType.Unknown
    var code = 0
    var response: PecomyApiResponse?
    
    init (code: Int?, response: PecomyApiResponse?){
        guard let response = response, code = code else {
            return
        }
        
        type = PecomyApiClientErrorType(errorCode: code, message: response.message)
        self.response = response
    }
    
    init (type: PecomyApiClientErrorType) {
        self.type = type
    }
}
