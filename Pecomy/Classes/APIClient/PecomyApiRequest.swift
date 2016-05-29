//
//  PecomyApiRequest.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import Alamofire

public protocol PecomyApiRequest {
    associatedtype Response
    
    var endpoint: String{ get }
    var method: Alamofire.Method{ get }
    var encoding: ParameterEncoding{ get }
    var headerParams: [String:String] { get }
    var params: [String:AnyObject]{ get }
}

extension PecomyApiRequest {
    var endpoint: String {
        return ""
    }
    
    var headerParams: [String:String] {
        return [:]
    }
    
    var params: [String:AnyObject] {
        return [:]
    }
}
