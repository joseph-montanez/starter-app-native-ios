//
//  LocalStorageTask.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/12/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
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
                    let error = NSError(domain: "No local storage to perform work on", code: 1001, userInfo: nil)
                    reject(error)
                }
            }
            return
        }
    }
    
    func checkToken(result: LocalStorage?, (error: NSError?, isCancelled: Bool)?) -> LSTask {
        return LSTask { progress, fulfill, reject, configure in
            Async.background() {
                if let store = result {
                    if count(store.token) == 0 {
                        //-- If there is no token we need to generate one
                        Alamofire.request(TokenApi.Generate(store.uuid)).responseJSON { (request, response, JSON, error) in
                            println("JSON: \(JSON), error: \(error) response: \(response) request: \(request)")
                            if let data = JSON as? [String:AnyObject?], let success = data["success"] as? Bool {
                                println("I GOT A TOKEN!!!")
                            } else {
                                println("I GOT A FAIL!!!")
                            }
                        }
                    } else {
                        println("I have a token")
                    }
                } else {
                    let error = NSError(domain: "No local storage to perform work on", code: 1001, userInfo: nil)
                    reject(error)
                }
                
                return
            }
            return
        }
    }
}