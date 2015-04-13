//
//  TokenApi.swift
//  Starter App
//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Joseph Montanez
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.

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