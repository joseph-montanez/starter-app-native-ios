//
//  StartController.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/11/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit

class StartController: UIViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //-- Find the local storage
        let storePromise = LocalStorage.getStorage()
        
        //-- Check for the UUID
        LocalStorage.checkUUID(storePromise)
        
        //-- Check for a token
    }
    
    override func viewDidLoad() {
        //-- This needs to be removed once logic is figured out
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("MarketingSegue", sender: self)
        }
    }
    
}
