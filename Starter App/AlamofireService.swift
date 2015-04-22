//
//  AlamofireService.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/22/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import Alamofire

public class AlamofireService {
    public init() {
        
    }
    
    public func encodeJson(URLRequest: URLRequestConvertible, parameters: [String: AnyObject]?) -> (NSURLRequest, NSError?) {
        return Alamofire.ParameterEncoding.JSON.encode(URLRequest, parameters: parameters)
    }
    
    public func setUp(path: String, method: String) -> NSMutableURLRequest {
        let URL = NSURL(string: Api.endPoint)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method
        
        if let token = SharedMemory.sharedInstance.token {
            mutableURLRequest.setValue(token, forHTTPHeaderField: "X-Token")
        }
        
        return mutableURLRequest
    }
}