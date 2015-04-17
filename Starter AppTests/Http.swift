//
//  Http.swift
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
//

import Foundation

func fromStream(request:NSURLRequest) -> NSData? {
    if let stream = request.HTTPBodyStream {
        var data = NSMutableData()
        var buffer = [UInt8](count: 4096, repeatedValue: 0)
        stream.open()
        while stream.hasBytesAvailable {
            let length = stream.read(&buffer, maxLength: 4096)
            if length == 0 {
                break
            } else {
                data.appendBytes(&buffer, length: length)
            }
        }
        return .Some(data)
    } else {
        return .None
    }
}

func fromBody(request:NSURLRequest) -> NSString? {
    if let body = request.HTTPBody {
        if let result = NSString(data: body, encoding: NSUTF8StringEncoding) {
            return .Some(result)
        } else {
            return .None
        }
    } else {
        return .None
    }
}

func jsonGoodResponse(request:NSURLRequest) -> NSHTTPURLResponse {
    return NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: ["Content-Type": "application/json"])!
}
