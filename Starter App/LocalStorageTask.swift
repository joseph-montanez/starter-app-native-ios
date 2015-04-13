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

class LocalStorageTask {
    typealias LSTask = SwiftTask.Task<Float, LocalStorage, NSError>
    
    func getStorage() -> LSTask {
        return LSTask { progress, fulfill, reject, configure in
            Async.background() {
                fulfill(LocalStorage.loadFromDisk())
            }
            return
        }
    }
    
    func checkUUID(result: LocalStorage?, (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return LSTask { progress, fulfill, reject, configure in
            Async.background() {
                if let store = result {
                    //-- Let see if the UUID if set!
                    if count(store.uuid) == 0 {
                        store.generateUUID()
                    }
                    
                    fulfill(store)
                } else {
                    let error = NSError(domain: "No local storage to perform work on", code: 1001,
                        userInfo: ["file": __FILE__, "line": __LINE__])
                    reject(error)
                }
            }
            return
        }
    }
    
    func getToken(result: LocalStorage?, (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return LSTask { progress, fulfill, reject, configure in
            Async.background() {
                if let store = result {
                    if count(store.token) == 0 {
                        //-- If there is no token we need to generate one
                        let req = Alamofire.request(TokenApi.Generate(store.uuid))
                        
                        req.responseJSON { (request, response, JSON, error) in
                            if let data = JSON as? [String:AnyObject],
                                let success = data["success"] as? Bool,
                                let token = data["token"] as? String {
                                store.token = token
                                fulfill(store)
                            } else {
                                reject(NSError(domain: "Unable to generate token from server", code: 1003,
                                    userInfo: ["file": __FILE__, "line": __LINE__]))
                            }
                        }
                    } else {
                        fulfill(store)
                    }
                } else {
                    reject(NSError(domain: "No local storage to add token too", code: 1002,
                        userInfo: ["file": __FILE__, "line": __LINE__]))
                }
                
                return
            }
            return
        }
    }
    
    func isAuthorized(result: LocalStorage?, (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return LSTask { progress, fulfill, reject, configure in
            Async.background() {
                if let store = result where count(store.token) > 0 {
                    //-- If there is no token we need to generate one
                    let req = Alamofire.request(TokenApi.Authenticate(store.uuid))
                    
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
                    reject(NSError(domain: "No token to perform authorization on", code: 1004,
                        userInfo: ["file": __FILE__, "line": __LINE__]))
                }

                return
            }
            return
        }
    }
}