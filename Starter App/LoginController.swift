//
//  LoginController.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/6/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    @IBOutlet weak var facebookViewContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var scrollContentView: UIView!
    
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            style: UIBarButtonItemStyle.Plain,
            target: self, action:"back:")
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
