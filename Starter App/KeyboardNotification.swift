//
//  KeyboardNotification.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/10/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit

/// Wrapper for the NSNotification userInfo values associated with a keyboard notification.
///
/// It provides properties retrieve userInfo dictionary values with these keys:
///
/// - UIKeyboardFrameBeginUserInfoKey
/// - UIKeyboardFrameEndUserInfoKey
/// - UIKeyboardAnimationDurationUserInfoKey
/// - UIKeyboardAnimationCurveUserInfoKey

public struct KeyboardNotification {
    
    let notification: NSNotification
    let userInfo: NSDictionary
    
    /// Initializer
    ///
    /// :param: notification Keyboard-related notification
    public init(_ notification: NSNotification) {
        self.notification = notification
        if let userInfo = notification.userInfo {
            self.userInfo = userInfo
        }
        else {
            self.userInfo = NSDictionary()
        }
    }
    
    /// Start frame of the keyboard in screen coordinates
    public var screenFrameBegin: CGRect {
        if let value = userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue {
            return value.CGRectValue()
        }
        else {
            return CGRectZero
        }
    }
    
    /// End frame of the keyboard in screen coordinates
    public var screenFrameEnd: CGRect {
        if let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            return value.CGRectValue()
        }
        else {
            return CGRectZero
        }
    }
    
    /// Keyboard animation duration
    public var animationDuration: Double {
        if let number = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber {
            return number.doubleValue
        }
        else {
            return 0.25
        }
    }
    
    /// Keyboard animation curve
    ///
    /// Note that the value returned by this method may not correspond to a
    /// UIViewAnimationCurve enum value.  For example, in iOS 7 and iOS 8,
    /// this returns the value 7.
    public var animationCurve: Int {
        if let number = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber {
            return number.integerValue
        }
        return UIViewAnimationCurve.EaseInOut.rawValue
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// :param: view UIView to whose coordinate system the frame will be converted
    /// :returns: frame rectangle in view's coordinate system
    public func frameBeginForView(view: UIView) -> CGRect {
        return view.convertRect(screenFrameBegin, fromView: view.window)
    }
    
    /// Start frame of the keyboard in coordinates of specified view
    ///
    /// :param: view UIView to whose coordinate system the frame will be converted
    /// :returns: frame rectangle in view's coordinate system
    public func frameEndForView(view: UIView) -> CGRect {
        return view.convertRect(screenFrameEnd, fromView: view.window)
    }
    
    public func animationOptionsWithCurve(curve: UIViewAnimationCurve) -> UIViewAnimationOptions
    {
        
        switch curve {
        case UIViewAnimationCurve.EaseInOut:
            return UIViewAnimationOptions.CurveEaseInOut;
        case UIViewAnimationCurve.EaseIn:
            return UIViewAnimationOptions.CurveEaseIn;
        case UIViewAnimationCurve.EaseOut:
            return UIViewAnimationOptions.CurveEaseOut;
        case UIViewAnimationCurve.Linear:
            return UIViewAnimationOptions.CurveLinear;
        }
    }
    
    public func animationCurveWithOptions(curve: UIViewAnimationOptions) -> UIViewAnimationCurve
    {
        
        switch curve {
        case UIViewAnimationOptions.CurveEaseInOut:
            return UIViewAnimationCurve.EaseInOut
        case UIViewAnimationOptions.CurveEaseIn:
            return UIViewAnimationCurve.EaseIn
        case UIViewAnimationOptions.CurveEaseOut:
            return UIViewAnimationCurve.EaseOut
        case UIViewAnimationOptions.CurveLinear:
            return UIViewAnimationCurve.Linear
        default:
            return UIViewAnimationCurve.EaseInOut
        }
    }
}