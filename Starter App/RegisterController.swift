//
//  LoginController.swift
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
import Bond
import SwiftyJSON
import SCLAlertView
import SwiftSpinner

class RegisterController: UIViewController {
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var password_confirm: UITextField!
    
    let viewModel = RegisterViewViewModel()
    
    override func viewWillAppear(animated: Bool) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.email <->> email.dynText
        viewModel.password <->> password.dynText
        viewModel.password_confirm <->> password_confirm.dynText
        
    }
    
    @IBAction func back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func register(sender: AnyObject) {
        SwiftSpinner.show("Registering")
        
        let task = UserTask()
        let job = task.register(viewModel)
        job.then { (data: UserApi.RegisterResponse?, result: (error: NSError?, isCancelled: Bool)?) -> UserApi.RegisterResponse in
            
            SwiftSpinner.hide() { _ in
                switch (data, result) {
                case (.Some(success:true, messages:_), .None):
                    //-- All is well!
                    // TODO: Lets log them in baby!
                    break
                default:
                    //-- Bad juju!
                    let message: String
                    if let success = data?.success, let messages = data?.messages where !success {
                        message = messages.reduce("", combine: { (result, message: (key: String, response: String)) -> String in
                            return "\(result)\n\(message.response)"
                        })
                    } else {
                        message = result?.error?.domain ?? "Server Error"
                    }
                    SCLAlertView().showError("Registration Failed".localized, subTitle: message)
                    break
                }
                return
            }
            return UserApi.RegisterResponse(false, [])
        }
    }
}