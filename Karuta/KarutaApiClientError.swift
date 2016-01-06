//
//  KarutaApiClientError.swift
//  Karuta
//
//  Created by 韮澤賢三 on 2016/01/05.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

public enum KarutaApiClientErrorType: ErrorType {
    case JsonParse
    case Mapping
    case Timeout //ネットワーク不通によるエラー
    case Cancelled //キャンセル実行時のエラー
    case Unknown //どのエラーにも該当しないエラー
    
    case InvalidID // 400
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
        case 500:
            self = .ServerError
        case 404:
            self = .NoResult
        default:
            self = .Unknown
        }
    }
}

public struct KarutaApiClientError {
    var type = KarutaApiClientErrorType.Unknown
    var code = 0
    var response: KarutaApiResponse?
    
    init (code: Int?, response: KarutaApiResponse?){
        guard let response = response, code = code else {
            return
        }
        
        type = KarutaApiClientErrorType(errorCode: code, message: response.message)
        self.response = response
    }
    
    init (type: KarutaApiClientErrorType) {
        self.type = type
    }
}
