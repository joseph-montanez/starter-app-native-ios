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

class LocalStorage: RLMObject {
    typealias LocalStorageTask = SwiftTask.Task<Float, LocalStorage, NSError>
    dynamic var id = 1
    dynamic var token = ""
    dynamic var uuid = ""
    dynamic var user: User?
    
    func generateUUID() -> String {
        let identifier = NSUUID().UUIDString
        uuid = identifier
        return identifier
    }
    
    func saveToDisk() {
        let realm = SharedMemory.sharedInstance.defaultRealm
        
        realm.beginWriteTransaction()
        LocalStorage.createOrUpdateInRealm(realm, withObject: self)
        realm.commitWriteTransaction()
        
    }
    
    static func loadFromDisk() -> LocalStorage {
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