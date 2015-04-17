//
//  LocalStorageTaskTests.swift
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


import Starter_App
import Quick
import Nimble
import Mockingjay
import Alamofire
import SwiftyJSON

class LocalStorageTaskSpec: QuickSpec {
    override func spec() {
        
        beforeEach {
//            self.stub(everything, builder: { (request:NSURLRequest) -> Response in
//                println(request.URL?.path)
//                let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: nil)!
//                let data:NSData? = nil
//                return .Success(response, data)
//            })
            self.stub(uri("/api/v1/token/generate"), builder: { (request:NSURLRequest) -> Response in
                let response = jsonGoodResponse(request)
                
                if let data = fromStream(request),
                    let uuid = JSON(data: data)["uuid"].string where count(uuid) > 0 {
                    return .Success(response, JSON(["message": "123", "success": true]).rawData())
                } else {
                    return .Success(response, JSON([
                        "message": "A UUID is required to generate a token",
                        "success": false
                        ]).rawData())
                }
            })
            
        }
        
        describe("the local storage") {
            it("something useful") {
                var foo: LocalStorage = LocalStorage()
                
                let job = LocalStorageTask()
                let task = job.wrap(foo)
                task.then(job.getToken).success { store -> Void in
                    println("success! \(store.token)")
                }.failure { (error: NSError?, isCancelled: Bool) -> Void in
                        println("failure! \(error)")
                }
                
                expect{foo.token}.toEventually(equal("123"), timeout: 3)
            }
        }
    }
}
