//
//  RegisterViewState.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/23/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import Bond

public class RegisterViewViewModel {
    let email = Dynamic<String>("")
    let password =  Dynamic<String>("")
    let password_confirmation = Dynamic<String>("")
    
    init() {
    }
}

//public class RegisterViewViewModelFromRegister : RegisterViewViewModel {
//    public let email: String
//    public let password: String
//    public let password_confirm: String
//    
//    public init(_ register: Re) {
//        self.email = email
//        self.password = password
//        self.password_confirm = password_confirm
//    }
//    
//}