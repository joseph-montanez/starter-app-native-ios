//
//  LocalStorage.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/11/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import Realm
import SwiftTask
import Async

class LocalStorage: RLMObject {
    typealias LocalStorageTask = SwiftTask.Task<Float, LocalStorage, NSError>
    
    dynamic var token = ""
    dynamic var uuid = ""
    dynamic var user: User?
    
    func generateUUID() -> String {
        let identifier = NSUUID().UUIDString
        uuid = identifier
        return identifier
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