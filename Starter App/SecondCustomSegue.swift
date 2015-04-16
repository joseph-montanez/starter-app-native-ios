//
//  SecondCustomSegue.swift
//  CustomSegues
//
//  Created by Gabriel Theodoropoulos on 20/12/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
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
