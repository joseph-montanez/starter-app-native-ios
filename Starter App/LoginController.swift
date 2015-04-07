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
    
    var lastVisibleView: UIView?
    var visibleMargin: CGFloat?
    var visibleOffset: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillShow:",name:UIKeyboardWillShowNotification,object:nil)
        //https://github.com/damienromito/VisibleFormViewController/blob/master/VisibleFormViewController/VisibleFormViewController.m
        //NSNotificationCenter.defaultCenter().addObserver(self, selector:"keyboardWillHide:",name:UIKeyboardWillHideNotification,object:nil)
        
    }
    
    func keyboardWillShow(notification:NSNotification) {
        let dict:NSDictionary = notification.userInfo as [String:AnyObject]
        let keyboardFrameEndUserInfoKey = dict.valueForKey(UIKeyboardFrameEndUserInfoKey) as NSValue
        let keyboardBounds = keyboardFrameEndUserInfoKey.CGRectValue()
        
        
        let duration = dict.objectForKey(UIKeyboardAnimationDurationUserInfoKey) as NSNumber
        let curve = dict.objectForKey(UIKeyboardAnimationCurveUserInfoKey) as NSNumber
        
        let frame = view.frame
        let visibleHeight = frame.size.height - keyboardBounds.size.height
        
        let lastVisiblePointY = lastVisibleView!.frame.origin.y + lastVisibleView!.frame.size.height
        
        let zeroFloat: CGFloat = 0.00
        
        switch (visibleOffset, visibleMargin, visibleHeight, lastVisiblePointY) {
        case (let offset, let margin, let height, let pointY):
            if (lastVisibleView != nil && offset == zeroFloat && (pointY + margin!) > height) {
                visibleOffset = lastVisiblePointY - height + margin!
                //frame.origin.y -= offset;
            }
            
        }
        
        
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(duration.doubleValue)
        //UIView.setAnimationCurve(curve.intValue)
        
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
