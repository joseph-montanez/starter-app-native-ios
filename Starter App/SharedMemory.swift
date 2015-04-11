//
//  SharedMemory.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/11/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import Realm

class SharedMemory {
    let defaultRealm: RLMRealm
    static let sharedInstance = SharedMemory()
    
    init() {
        defaultRealm = RLMRealm.defaultRealm()
    }
    
}