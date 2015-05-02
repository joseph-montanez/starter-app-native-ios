//
//  User.swift
//  Starter App
//
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

import Realm
import SwiftyJSON

class User: RLMObject {
    dynamic var id = 0
    dynamic var firstName = ""
    
    
    
    func register(email: String, password: String, password_confirmation: String, fulfill: UserApi.RegisterResponseFn, reject: (NSError -> Void)) {
        
        let http = App.getHttpService()
        let urlReq = UserApi().register(email, password: password, password_confirmation: password);
        let req = http.request(urlReq)
        
        Api.request(req).success { (request, response, optionalJson, optionalString, error) -> Void in
            if let data = Api.good(optionalJson)  {
                if let success = data["success"].bool where success == true {
                    let messages = [(String,String)]()
                    let result = (success: true, messages: messages)
                    fulfill(result)
                } else {
                    //-- There were error
                    let messages = Api.getMessageBag(data)
                    let result = (success: false, messages: messages)
                    fulfill(result)
                }
            } else {
                let domain: String = optionalString ?? error?.domain ?? Api.SERVER_ERROR.0
                let code: Int = error?.code ?? Api.SERVER_ERROR.1
         
                reject(NSError(domain: domain, code: code,
                    userInfo: ["file": __FILE__, "line": __LINE__]))
            }
            
            return
        }
    }
}