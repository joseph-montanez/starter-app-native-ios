//
//  LocalStorage.swift
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
import Realm
import SwiftTask
import Async
import SwiftyJSON

public class LocalStorage: RLMObject {
    typealias LocalStorageTask = SwiftTask.Task<Float, LocalStorage, NSError>
    dynamic var id = 1
    public dynamic var token = ""
    dynamic var uuid = ""
    dynamic var user: User?
    
    public func generateUUID() -> String {
        let identifier = NSUUID().UUIDString
        uuid = identifier
        return identifier
    }
    
    public func authorize(fulfill: (LocalStorage -> Void), reject: (NSError -> Void)) {
        //-- If there is no token we need to generate one
        let http = App.getHttpService()
        let req = http.request(TokenApi().authenticate(uuid))
        req.responseJSON { (request, response, optionalJson, error) in
            if let json: AnyObject = optionalJson,
                let data = .Some(JSON(json)),
                let success = data["success"].bool,
                let authorized = data["authorized"].bool
                where authorized == true {
                    fulfill(self)
            } else {
                reject(NSError(domain: "Not authorized", code: Api.UNATHORIZED,
                    userInfo: ["file": __FILE__, "line": __LINE__]))
            }
        }
    }
    
    public func generateToken(fulfill: (LocalStorage -> Void), reject: (NSError -> Void)) {
        //-- If there is no token we need to generate one
        let http = App.getHttpService()
        let req = http.request(TokenApi().generate(uuid))
        req.responseJSON { (request, response, optionalJson, error) in
            if let json: AnyObject = optionalJson,
                let data = .Some(JSON(json)),
                let success = data["success"].bool,
                let token = data["token"].string
                where count(token) > 0 {
                    self.token = token
                    fulfill(self)
            } else {
                reject(NSError(domain: "Not authorized", code: Api.UNATHORIZED,
                    userInfo: ["file": __FILE__, "line": __LINE__]))
            }
        }
    }
    
    public func saveToDisk() {
        let realm = SharedMemory.sharedInstance.defaultRealm
        
        realm.beginWriteTransaction()
        LocalStorage.createOrUpdateInRealm(realm, withObject: self)
        realm.commitWriteTransaction()
        
    }
    
    override public class func primaryKey() -> String {
        return "id"
    }
    
    public static func loadFromDisk() -> LocalStorage {
        let realm = SharedMemory.sharedInstance.defaultRealm
        
        let storages = LocalStorage.allObjects()
        if storages.count == 0 {
            //-- They never used this app! Let go intialize a storage for them.
            return LocalStorage()
        } else {
            let found: Bool
            switch storages[0] {
            case let storage as LocalStorage:
                return storage
            default:
                //-- Something is really wrong! Let try to fix this!
                realm.beginWriteTransaction()
                for item in storages {
                    realm.deleteObject(item)
                }
                realm.commitWriteTransaction()
                
                // Alright everything is delete now lets start over...
                return LocalStorage()
            }
        }
    }
}