//
//  LocalStorageTask.swift
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
import SwiftTask
import Async
import Alamofire
import SwiftyJSON
//import Alamofire_SwiftyJSON

public class LocalStorageTask {
    public typealias LSTask = SwiftTask.Task<Float, LocalStorage, NSError>
    
    var task: LSTask?
    
    public init () {
        
    }
    
    public func wrap(store: LocalStorage) -> LSTask {
        return LSTask { progress, fulfill, reject, configure in
            fulfill(store)
            return
        }
    }
    
    public func exec() -> LSTask {
        //-- Lets start to process user auth as soon as possible!
        let task = LocalStorageTask()
        //-- Get storage from disk
        return task.getStorage()
            //-- See if there is a UUID assigned
            .then(task.checkUUID)
            //-- Check if there is a token
            .then(task.getToken)
            //-- Check to see if token is authorized
            .then(task.isAuthorized)
    }
        
    public func getStorage() -> LSTask {
        return AsyncTask.background { (_, fulfill: LocalStorage -> Void, _, _) in
            fulfill(LocalStorage.loadFromDisk())
            return
        }
    }
    
    public func checkUUID(result: LocalStorage?, errorInfo: (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return AsyncTask.background { (_, fulfill: LocalStorage -> Void, reject, _) in
            if let store = result {
                //-- Let see if the UUID if set!
                if count(store.uuid) == 0 {
                    store.generateUUID()
                }
                
                fulfill(store)
            } else {
                reject(errorInfo?.0 ?? NSError(domain: "No local storage to perform work on", code: 1001,
                    userInfo: ["file": __FILE__, "line": __LINE__]))
            }
            return
        }
    }
    
    public func getToken(result: LocalStorage?, errorInfo: (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return AsyncTask.background { (_, fulfill: LocalStorage -> Void, reject, _) in
            if let store = result where count(store.token) > 0 {
                fulfill(store)
            } else if let store = result where count(store.token) == 0 {
                //-- If there is no token we need to generate one
                let req = Alamofire.request(TokenApi().generate(store.uuid))
                
                req.responseJSON { (request, response, nullableJson, error) -> Void in
                    let defaultError = NSError(domain: "Unable to generate token from server", code: 1003,
                        userInfo: ["file": __FILE__, "line": __LINE__])
                    if error != nil {
                        reject(error ?? defaultError)
                    } else if let json: AnyObject = nullableJson {
                        let data = JSON(json)
                        if let success = data["success"].bool,
                            let token = data["token"].string {
                                store.token = token
                                fulfill(store)
                        } else {
                            let domain = data["message"].string ?? "Unable to generate token from server"
                            reject(NSError(domain: domain, code: 1003,
                                userInfo: ["file": __FILE__, "line": __LINE__]))
                        }
                    } else {
                        reject(defaultError)
                    }
                    return
                }
            } else {
                reject(errorInfo?.0 ?? NSError(domain: "No local storage to add token too", code: 1002,
                    userInfo: ["file": __FILE__, "line": __LINE__]))
            }
            
            return
        }
    }
    
    public func isAuthorized(result: LocalStorage?, errorInfo: (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return AsyncTask.background { (_, fulfill: LocalStorage -> Void, reject, _) in
            if let store = result where count(store.token) > 0 {
                //-- If there is no token we need to generate one
                let req = Alamofire.request(TokenApi().authenticate(store.uuid))
                
                req.responseJSON { (request, response, JSON, error) in
                    if let data = JSON as? [String:AnyObject],
                        let success = data["success"] as? Bool,
                        let authorized = data["authorized"] as? Bool
                        where authorized == true {
                            fulfill(store)
                    } else {
                        reject(NSError(domain: "Not authorized", code: Api.UNATHORIZED,
                            userInfo: ["file": __FILE__, "line": __LINE__]))
                    }
                }
            } else {
                reject(errorInfo?.0 ?? NSError(domain: "No token to perform authorization on", code: 1004,
                    userInfo: ["file": __FILE__, "line": __LINE__]))
            }

            return
        }
    }
}