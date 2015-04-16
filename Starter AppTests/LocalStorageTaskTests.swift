//
//  LocalStorageTaskTests.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/16/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//


import Starter_App
import Quick
import Nimble
import Mockingjay
import Alamofire

class LocalStorageTaskSpec: QuickSpec {
    override func spec() {
        
        beforeEach {
            let body = [ "success": true, "token": "123" ]
            self.stub(everything, builder: { (request:NSURLRequest) -> Response in
                if let body = request.HTTPBody {
                    let n = NSString(data: body, encoding: NSUTF8StringEncoding)
                    println(n)
                } else {
                    println("no http body")
                }
                if let stream = request.HTTPBodyStream {
                    var data = NSMutableData()
                    var buffer = [UInt8](count: 4096, repeatedValue: 0)
                    stream.open()
                    while stream.hasBytesAvailable {
                        let length = stream.read(&buffer, maxLength: 4096)
                        if length == 0 {
                            break
                        } else {
                            data.appendBytes(&buffer, length: length)
                        }
                    }
                    println("stream \(NSString(data: data, encoding: NSUTF8StringEncoding)!)")
                } else {
                    println("no stream")
                }
                
                switch NSURLProtocol.propertyForKey("uuid", inRequest: request) {
                case (let uuid as String):
                    println("uuid string \(uuid)")
                    break
                case (let uuid as NSData):
                    println("uuid nsdata \(uuid)")
                    break
                case (let uuid as NSString):
                    println("uuid nsdata \(uuid)")
                    break
                default:
                    break
                }
                let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: ["Content-Type": "application/json"])!
                let data:NSData? = "{\"success\": true, \"token\": \"123\"}".dataUsingEncoding(NSUTF8StringEncoding)
                return .Success(response, data)
            })
            

            self.stub(http(.POST, "/token/generate"), builder: { (request:NSURLRequest) -> Response in
                let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: nil, headerFields: ["Content-Type": "application/json"])!
                let data:NSData? = "{\"success\": true, \"token\": \"123\"}".dataUsingEncoding(NSUTF8StringEncoding)
                return .Success(response, data)
            })
            
        }
        
        describe("peeling the banana") {
            it("is edible") {
                let reqUrl = TokenApi.Generate("abc")
                let path = reqUrl.path
                let req = Alamofire.request(reqUrl)
                
                var foo: LocalStorage = LocalStorage()
                
                req.responseJSON { (request, response, JSON, error) in
                    if let data = JSON as? [String:AnyObject],
                        let success = data["success"] as? Bool,
                        let token = data["token"] as? String {
                            println("token \(token)")
                            foo.token = token
                    } else {
                        foo.token = ""
                        println("Unable to generate token from server \(JSON)")
                    }
                }
                
                expect{foo.token}.toEventually(equal("123"), timeout: 1)
            }
        }
    }
}
