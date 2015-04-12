//
//  StartController.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/11/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit
import Async

class StartController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        
        //-- Find the local storage
        let task = LocalStorageTask()
        //-- Get storage from disk
        task.getStorage()
        //-- See if there is a UUID assigned
        .then(task.checkUUID)
        //-- Check if there is a token
        .then(task.checkToken)
        
        //-- Check for a token
    }
    
    override func viewDidLoad() {
        //-- This needs to be removed once logic is figured out
        Async.main() {
            self.performSegueWithIdentifier("MarketingSegue", sender: self)
            return
        }
    }
    

}