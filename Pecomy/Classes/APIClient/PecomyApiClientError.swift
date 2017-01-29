//
//  PecomyApiClientError.swift
//  Pecomy
//
//  Created by 韮澤賢三 on 2016/01/05.
//  Copyright © 2016 Pecomy. All rights reserved.
//

public enum PecomyApiClientErrorType: Error {
    case jsonParse
    case mapping
    case timeout //ネットワーク不通によるエラー
    case cancelled //キャンセル実行時のエラー
    case unknown //どのエラーにも該当しないエラー
    
    case invalidID // 400
    case unauthorized // 401
    case serverError // 500
    case noResult // 404
    
    init(errorCode: Int?, message: String) {
        guard let code = errorCode else {
            self = .unknown
            return
        }
        switch code {
        case 400:
            self = .invalidID
        case 401:
            self = .unauthorized
        case 500:
            self = .serverError
        case 404:
            self = .noResult
        default:
            self = .unknown
        }
    }
}

public struct PecomyApiClientError {
    var type = PecomyApiClientErrorType.unknown
    var code = 0
    var response: PecomyApiResponse?
    
    init (code: Int?, response: PecomyApiResponse?){
        guard let response = response, let code = code else {
            return
        }
        
        type = PecomyApiClientErrorType(errorCode: code, message: response.message)
        self.response = response
    }
    
    init (type: PecomyApiClientErrorType) {
        self.type = type
    }
}
