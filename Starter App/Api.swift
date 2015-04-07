//
//  Api.swift
//  Starter App
//
//  Created by Bernard Kohantob on 4/7/15.
//  Copyright (c) 2015 Comentum. All rights reserved.
//

import Foundation
import PromiseKit
import Dollar

class Api {
    let endPoint = "http://hawk2.comentum.com/templates/start-app-laravel"
    
    func parseJson(jsonData: NSData) -> NSArray {
        var error: NSError?
        let jsonDict = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: &error) as NSArray
        return jsonDict
    }
    /*
    func search(value: String) -> Promise<[TPSearchItem]> {
        let searchEndPoint = "\(endPoint)/related-keywords.php"
        let params = ["term":value];
        let promise = Promise<[TPSearchItem]> { fulfiller, rejecter in
            let request:Promise<NSArray> = NSURLConnection.GET(searchEndPoint, query: params)
            request.then { (jsonResults:NSArray) -> Void in
                let rows = jsonResults as [NSDictionary]
                let items = $.reduce(rows, initial: [TPSearchItem]()) { (collection, dict) in
                    if let item = TPSearchItem(label: dict["label"] as String, value: dict["value"] as String) {
                        return collection + [item]
                    } else {
                        return collection
                    }
                }
                fulfiller(items)
            }
            request.catch { (error:NSError) -> Void in
                rejecter(error)
            }
        }
        
        return promise
    }
    
    func detail(companyId: Int) -> Promise<TPCompany> {
        let searchEndPoint = "\(endPoint)/ajax-details.php"
        let params = ["companies_id":String(companyId)];
        
        let promise = Promise<TPCompany> { fulfiller, rejecter in
            let request:Promise<NSDictionary> = NSURLConnection.GET(searchEndPoint, query: params)
            request.then { (jsonResults:NSDictionary) -> Void in
                let company = TPCompany()
                company.fromJson(jsonResults)
                fulfiller(company)
            }
            request.catch { (error:NSError) -> Void in
                rejecter(error)
            }
        }
        
        return promise
    }
    
    func listing(keywordId: String) -> Promise<[TPCompany]> {
        let searchEndPoint = "\(endPoint)/ajax-listing.php"
        let params = ["keywords_id":keywordId, "companies": "true"];
        
        let promise = Promise<[TPCompany]> { fulfiller, rejecter in
            let request:Promise<NSDictionary> = NSURLConnection.GET(searchEndPoint, query: params)
            request.then { (jsonResults:NSDictionary) -> Void in
                let category = jsonResults["category"] as NSDictionary
                let companies = jsonResults["companies"] as NSArray
                let rows = companies as [NSDictionary]
                let items = $.reduce(rows, initial: [TPCompany]()) { (collection, dict) in
                    let company = TPCompany()
                    company.fromJson(dict)
                    return collection + [company]
                }
                fulfiller(items)
            }
            request.catch { (error:NSError) -> Void in
                rejecter(error)
            }
        }
        
        return promise
    }
    */
}