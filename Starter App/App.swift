//
//  App.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/24/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation

class App {
    static func getHttpService() -> HttpService {
        return HttpService()
    }
    static func getHttpRequestService() -> HttpRequestService {
        return HttpRequestService()
    }
}