//
//  UserApi.swift
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

import Foundation
import Alamofire

public class UserApi {
    static var prefix: String = "/user"
    
    public var service: HttpService?
    
    public typealias RegisterResponse = (success: Bool, messages: [(String,String)])
    public typealias RegisterResponseFn = RegisterResponse -> Void
    
    public init(service: HttpService = App.getHttpService()) {
        self.service = service
    }
    
    public func register(email: String, password: String, password_confirm: String, service: HttpService = App.getHttpService()) -> NSURLRequest {
        let setup = service.setUp(UserApi.prefix + "/register", method: "POST")
        return service.encodeJson(setup, parameters: [
            "email": email,
            "password": password,
            "password_confirm": password_confirm
            ]).0
    }
    
    public func login(email: String, password: String, service: HttpService = App.getHttpService()) -> NSURLRequest {
        let setup = service.setUp(UserApi.prefix + "/login", method: "POST")
        return service.encodeJson(setup, parameters: ["email": email, "password": password]).0
    }
    
    public func user(service: HttpService = App.getHttpService()) -> NSURLRequest {
        let setup = service.setUp(UserApi.prefix + "/validate", method: "GET")
        return service.encode(setup, parameters: nil).0
    }
}