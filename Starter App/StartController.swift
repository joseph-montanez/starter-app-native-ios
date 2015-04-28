//
//  StartController.swift
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

import UIKit
import Async

class StartController: UIViewController {
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //-- User is authorized,
        appDelegate.job!.success { (store: LocalStorage) -> LocalStorage in
            //-- Save to disk
            Async.background() {
                store.saveToDisk()
            }
            
            Async.main() {
                self.performSegueWithIdentifier("HomeSegue", sender: self)
                return
            }
            return store
        }
        
        //-- User is not authorized
        appDelegate.job!.failure { (error: NSError?, isCancelled: Bool) -> LocalStorage in
            Async.main() {
                self.performSegueWithIdentifier("MarketingSegue", sender: self)
                return
            }
            return LocalStorage()
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}