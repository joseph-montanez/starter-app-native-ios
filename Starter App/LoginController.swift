//
//  LoginController.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/6/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var facebookViewContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    
    var lastVisibleView: UIView?
    var visibleMargin: CGFloat = 0.0
    var visibleOffset: CGFloat = 0.0
    
    override func loadView() {
        super.loadView()
        lastVisibleView = loginButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        visibleMargin = CGFloat(self.edgesForExtendedLayout.rawValue)
        
        
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard:")
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:",name:UIKeyboardWillShowNotification,object:nil)
        //https://github.com/damienromito/VisibleFormViewController/blob/master/VisibleFormViewController/VisibleFormViewController.m
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillHide:",name:UIKeyboardWillHideNotification,object:nil)
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let kn = KeyboardNotification(notification)
        let dict:NSDictionary = notification.userInfo as [String:AnyObject]
        let keyboardFrameEndUserInfoKey = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let keyboardBounds = keyboardFrameEndUserInfoKey.CGRectValue()
        
        
        let duration = dict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as NSNumber
        let curve = kn.animationCurve
        
        var frame = view.frame
        let visibleHeight = frame.size.height - keyboardBounds.size.height
        
        var lastVisiblePointY: CGFloat
        if let last = lastVisibleView {
            lastVisiblePointY = last.frame.origin.y + last.frame.size.height
        } else {
            lastVisiblePointY = 0.0
        }
        
        let zeroFloat: CGFloat = 0.00
        
        var navigationBarHeight: CGFloat
        
        if let navigation = self.navigationController {
            navigationBarHeight = navigation.navigationBar.frame.height
        } else {
            navigationBarHeight = 0.0
        }
        
        
        if (lastVisibleView != nil && visibleOffset == zeroFloat && (lastVisiblePointY + visibleMargin) > visibleHeight) {
            self.visibleOffset = visibleHeight - navigationBarHeight /* Navigation UI Height */ - 4 /* Default Margin */
            frame.origin.y -= self.visibleOffset
        }
        
        let options = UIViewAnimationOptions(UInt(curve << 16))
        let durationInterval: NSTimeInterval = NSTimeInterval(duration.doubleValue)
        let delayInterval: NSTimeInterval = NSTimeInterval(0.0)

        UIView.animateWithDuration(
            durationInterval,
            delay: delayInterval,
            options: options,
            animations: { () -> Void in },
            completion: nil
        )
        
        view.frame = frame
        
        UIView.commitAnimations()
    }
    
    func keyboardWillHide(notification:NSNotification) {
        let kn = KeyboardNotification(notification)
        let dict:NSDictionary = notification.userInfo as [String:AnyObject]
        let duration = dict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as NSNumber
        let curve = kn.animationCurve
    
        var frame = self.view.frame;
        frame.origin.y += visibleOffset
        visibleOffset = 0
        
        
        let options = UIViewAnimationOptions(UInt(curve << 16))
        let durationInterval: NSTimeInterval = NSTimeInterval(duration.doubleValue)
        let delayInterval: NSTimeInterval = NSTimeInterval(0.0)
        
        UIView.animateWithDuration(
            durationInterval,
            delay: delayInterval,
            options: options,
            animations: { () -> Void in },
            completion: nil
        )
        
        view.frame = frame
        
        UIView.commitAnimations()
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    func dismissKeyboard(sender: UITapGestureRecognizer!) {
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is logged in, do work such as go to next view controller.
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let backButton = UIBarButtonItem(
            title: "Back",
            style: UIBarButtonItemStyle.Bordered,
            target: self, action:"back:")
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
