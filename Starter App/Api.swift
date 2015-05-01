//
//  Api.swift
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
import SwiftyJSON
import Async

public class Api {
    static let UNATHORIZED = 1005
    static let SERVER_ERROR = ("Server Error", 1006)
    static let VALIDATION_ERROR = ("Validation Error", 1007)
    static let endPoint = "http://localhost:8000/api/v1"
    
    public enum Request {
        case TokenGenerate
        case TokenAuthorize
        case TokenValidate
    }
    
    static func good(optionalJson: AnyObject?) -> JSON? {
        if let json: AnyObject = optionalJson, let data = .Some(JSON(json)) {
            //-- See if there is a new Token
            Api.token(data)
            
            if let success = data["success"].bool {
                return data
            } else {
                return .None
            }
        } else {
            return .None
        }
    }
    
    static func token(data: JSON) {
        if let token = data["token"].string where count(token) > 0 {
            let task = LocalStorageTask()
            task.getStorage().success { store -> LocalStorage in
                if store.token != token {
                    store.token = token
                    Async.background {
                        store.saveToDisk()
                        return
                    }
                }
                return store
            }
        }
    }
    
    static func getMessageBag(data: JSON) -> [(String, String)] {
        var messages = [(String, String)]()
        for (key: String, error: JSON) in data["messages"] {
            for (index: String, message: JSON) in error {
                println("\(key): \(message) ")
                messages.append((key, message.string ?? ""))
            }
        }
        return messages
    }
}