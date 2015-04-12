//
//  TokenApi.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/12/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import Alamofire

enum TokenApi: URLRequestConvertible {
    static var prefix: String = "/token"
    
    case Generate(String)
    case Authenticate(String)
    case Validate(String)
    
    var method: Alamofire.Method {
        switch self {
        case .Generate:
            return .POST
        case .Authenticate:
            return .GET
        case .Validate:
            return .GET
        }
    }
    
    var path: String {
        switch self {
        case .Generate:
            return TokenApi.prefix + "/generate"
        case .Authenticate:
            return TokenApi.prefix + "/athorized"
        case .Validate:
            return TokenApi.prefix + "/validate"
        }
    }
    
    // MARK: URLRequestConvertible
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: Api.endPoint)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        if let token = SharedMemory.sharedInstance.token {
            mutableURLRequest.setValue(token, forHTTPHeaderField: "X-Token")
        }
        
        switch self {
        case .Generate(let uuid):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["uuid": uuid]).0
        case .Authenticate(let uuid):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["uuid": uuid]).0
        case Validate(let uuid):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["uuid": uuid]).0
        }
    }
}