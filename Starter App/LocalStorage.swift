//
//  LocalStorage.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/11/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import Realm
import PromiseKit

class LocalStorage: RLMObject {
    dynamic var token = ""
    dynamic var uuid = ""
    dynamic var user: User?
    
    func generateUUID() -> String {
        let identifier = NSUUID().UUIDString
        uuid = identifier
        return identifier
    }
    
    static func getStorage() -> Promise<LocalStorage> {
        let promise = Promise<LocalStorage> { fulfiller, rejecter in
            let realm = SharedMemory.sharedInstance.defaultRealm
            
            let storages = LocalStorage.allObjects()
            let storage: LocalStorage
            if storages.count == 0 {
                //-- They never used this app! Let go intialize a storage for them.
                storage = LocalStorage()
            } else {
                let found: Bool
                switch storages[0] {
                case let item as LocalStorage:
                    storage = item
                default:
                    //-- Something is really wrong! Let try to fix this!
                    realm.beginWriteTransaction()
                    for item in storages {
                        realm.deleteObject(item)
                    }
                    realm.commitWriteTransaction()
                    
                    // Alright everything is delete now lets start over...
                    storage = LocalStorage()
                }
            }
            
            fulfiller(storage)
            
            //-- I really dont like that this does not have a rejecter...
//            let error = NSError(domain: "Unable to intialize a local storage", code: 1000, userInfo: nil)
//            rejecter(error)
        }
        
        return promise
    }
    
    static func checkUUID(promise:Promise<LocalStorage>) -> Promise<LocalStorage> {
        return promise.then { store -> LocalStorage in
            //-- Let see if the UUID if set!
            if count(store.uuid) == 0 {
                store.generateUUID()
            }
            
            return store
        }
    }
}