//
//  SecondCustomSegue.swift
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

class SecondCustomSegue: UIStoryboardSegue {
   
    override func perform() {
        
        switch (sourceViewController, destinationViewController) {
        case (let sourceController as UIViewController, let destinationController as UIViewController):
            switch (sourceController.view, destinationController.view) {
            case (let sourceView as UIView, let destinationView as UIView):
                if let window = UIApplication.sharedApplication().keyWindow {
                    window.insertSubview(destinationView, belowSubview: sourceView)
                }
                
                destinationView.transform = CGAffineTransformScale(destinationView.transform, 0.001, 0.001)
                
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    sourceView.transform = CGAffineTransformScale(destinationView.transform, 0.001, 0.001)
                    
                    }) { (Finished) -> Void in
                        
                        UIView.animateWithDuration(0.5, animations: { () -> Void in
                            destinationView.transform = CGAffineTransformIdentity
                            
                            }, completion: { (Finished) -> Void in
                                
                                sourceView.transform = CGAffineTransformIdentity
                                self.sourceViewController.presentViewController(destinationController as UIViewController, animated: false, completion: nil)
                        })
                }
                break
            default:
                println("source or destination views are null")
                break
            }
            break
        default:
            println("source or destination controllers are null")
            break
        }
        
    }
}
