//
//  HttpRequestService.swift
//  Starter App
//
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
//

import Foundation
import Alamofire

public class HttpRequestService {
    public var request: Alamofire.Request?
    
    public init() {
        
    }
    
    public init(request: Alamofire.Request) {
        self.request = request
    }
    
    public func wrap(request: Alamofire.Request) -> HttpRequestService {
        return HttpRequestService(request: request)
    }
    
    public func responseString(encoding: NSStringEncoding? = nil, completionHandler: (NSURLRequest, NSHTTPURLResponse?, String?, NSError?) -> Void) -> Self  {
        request?.responseString(encoding: encoding, completionHandler: completionHandler)
        return self
    }
    
    public func responseJSON(options: NSJSONReadingOptions = NSJSONReadingOptions.AllowFragments, completionHandler: (NSURLRequest, NSHTTPURLResponse?, AnyObject?, NSError?) -> Void) -> Self {
        request?.responseJSON(options: options, completionHandler: completionHandler)
        return self
    }
}