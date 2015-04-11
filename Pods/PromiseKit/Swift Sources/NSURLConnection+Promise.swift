import Foundation
import OMGHTTPURLRQ


extension NSURLResponse {
    private var stringEncoding: UInt {
        if let encodingName = textEncodingName {
            let encoding = CFStringConvertIANACharSetNameToEncoding(encodingName)
            if encoding != kCFStringEncodingInvalidId {
                return CFStringConvertEncodingToNSStringEncoding(encoding)
            }
        }
        return NSUTF8StringEncoding
    }
}


private func fetch<T>(var request: NSURLRequest, body: ((T) -> Void, (NSError) -> Void, NSData, NSURLResponse) -> Void) -> Promise<T> {
    if request.valueForHTTPHeaderField("User-Agent") == nil {
        let rq = request.mutableCopy() as! NSMutableURLRequest
        rq.setValue(OMGUserAgent(), forHTTPHeaderField:"User-Agent")
        request = rq
    }

    return Promise<T> { (fulfiller, rejunker) in
        NSURLConnection.sendAsynchronousRequest(request, queue:Q) {
            (rsp, data, err) in

            assert(!NSThread.isMainThread())

            //TODO in the event of a non 2xx rsp, try to parse JSON out of the response anyway

            func rejecter(error: NSError) {
                var info: [NSObject: AnyObject] = error.userInfo ?? [:]
                info[NSURLErrorFailingURLErrorKey] = request.URL
                info[NSURLErrorFailingURLStringErrorKey] = request.URL!.absoluteString
                if data != nil {
                    info[PMKURLErrorFailingDataKey] = data!
                    let encoding = rsp?.stringEncoding ?? NSUTF8StringEncoding
                    if let str = NSString(data: data, encoding: encoding) {
                        info[PMKURLErrorFailingStringKey] = str
                    }
                }

                if rsp != nil {
                    info[PMKURLErrorFailingURLResponseKey] = rsp!
                }

                rejunker(NSError(domain:error.domain, code:error.code, userInfo:info))
            }

            if err != nil {
                rejecter(err)
            } else {
                if let response = (rsp as? NSHTTPURLResponse) where response.statusCode < 200 || response.statusCode >= 300 {
                    rejecter(NSError(domain: NSURLErrorDomain,
                                     code: NSURLErrorBadServerResponse,
                                     userInfo: [
                                         NSLocalizedDescriptionKey: "The server returned a bad HTTP response code",
                                     ]))
                } else {
                    body(fulfiller, rejecter, data, rsp)
                }
            }
        }
    }
}


private func fetchJSON<T>(request: NSURLRequest) -> Promise<T> {
    return fetch(request) { (fulfill, reject, data, _) in
        let result: Promise<T> = NSJSONFromDataT(data)
        if result.fulfilled {
            fulfill(result.value!)
        } else {
            reject(result.error!)
        }
    }
}


extension NSURLConnection {

    //TODO I couldn’t persuade Swift to process these generically hence the lack of DRY
    //TODO When you can DRY it out, add error handling for the NSURL?() initializer

    public class func GET(url:String) -> Promise<NSData> {
        return promise(NSURLRequest(URL:NSURL(string:url)!))
    }
    public class func GET(url:String) -> Promise<String> {
        return promise(NSURLRequest(URL:NSURL(string:url)!))
    }
    public class func GET(url:String) -> Promise<NSArray> {
        return promise(NSURLRequest(URL:NSURL(string:url)!))
    }
    public class func GET(url:String) -> Promise<NSDictionary> {
        return promise(NSURLRequest(URL:NSURL(string:url)!))
    }

    public class func GET(url:String, query:[String:String]) -> Promise<NSData> {
        return promise(OMGHTTPURLRQ.GET(url, query))
    }
    public class func GET(url:String, query:[String:String]) -> Promise<String> {
        return promise(OMGHTTPURLRQ.GET(url, query))
    }
    public class func GET(url:String, query:[String:String]) -> Promise<NSDictionary> {
        return promise(OMGHTTPURLRQ.GET(url, query))
    }
    public class func GET(url:String, query:[String:String]) -> Promise<NSArray> {
        return promise(OMGHTTPURLRQ.GET(url, query))
    }


    public class func POST(url:String, formData:[String:String]) -> Promise<NSData> {
        return promise(OMGHTTPURLRQ.POST(url, JSON: formData))
    }
    public class func POST(url:String, formData:[String:String]) -> Promise<String> {
        return promise(OMGHTTPURLRQ.POST(url, formData))
    }
    public class func POST(url:String, formData:[String:String]) -> Promise<NSArray> {
        return promise(OMGHTTPURLRQ.POST(url, formData))
    }
    public class func POST(url:String, formData:[String:String]) -> Promise<NSDictionary> {
        return promise(OMGHTTPURLRQ.POST(url, formData))
    }


    public class func POST(url:String, JSON json:[String:String]) -> Promise<NSData> {
        return promise(OMGHTTPURLRQ.POST(url, JSON: json))
    }
    public class func POST(url:String, JSON json:[String:String]) -> Promise<String> {
        return promise(OMGHTTPURLRQ.POST(url, JSON: json))
    }
    public class func POST(url:String, JSON json:[String:String]) -> Promise<NSArray> {
        return promise(OMGHTTPURLRQ.POST(url, JSON: json))
    }
    public class func POST(url:String, JSON json:[String:String]) -> Promise<NSDictionary> {
        return promise(OMGHTTPURLRQ.POST(url, JSON: json))
    }

    public class func POST(url:String, JSON json:[String:AnyObject]) -> Promise<NSDictionary> {
      return promise(OMGHTTPURLRQ.POST(url, JSON: json))
    }

    public class func POST(url:String, multipartFormData: OMGMultipartFormData) -> Promise<NSData> {
        return promise(OMGHTTPURLRQ.POST(url, multipartFormData))
    }
    public class func POST(url:String, multipartFormData: OMGMultipartFormData) -> Promise<String> {
        return promise(OMGHTTPURLRQ.POST(url, multipartFormData))
    }
    public class func POST(url:String, multipartFormData: OMGMultipartFormData) -> Promise<NSArray> {
        return promise(OMGHTTPURLRQ.POST(url, multipartFormData))
    }
    public class func POST(url:String, multipartFormData: OMGMultipartFormData) -> Promise<NSDictionary> {
        return promise(OMGHTTPURLRQ.POST(url, multipartFormData))
    }


    public class func promise(rq:NSURLRequest) -> Promise<NSData> {
        return fetch(rq) { (fulfill, _, data, _) in
            fulfill(data)
        }
    }

    public class func promise(rq: NSURLRequest) -> Promise<String> {
        return fetch(rq) { (fulfiller, rejecter, data, rsp) in
            let str = NSString(data: data, encoding:rsp.stringEncoding)
            if str != nil {
                fulfiller(str! as String)
            } else {
                let info = [NSLocalizedDescriptionKey: "The server response was not textual"]
                rejecter(NSError(domain:NSURLErrorDomain, code: NSURLErrorBadServerResponse, userInfo:info))
            }
        }
    }

    public class func promise(request: NSURLRequest) -> Promise<NSDictionary> {
        return fetchJSON(request)
    }

    public class func promise(request: NSURLRequest) -> Promise<NSArray> {
        return fetchJSON(request)
    }
}


#if os(iOS)
import UIKit.UIImage

extension NSURLConnection {

    public class func GET(url:String) -> Promise<UIImage> {
        return promise(NSURLRequest(URL:NSURL(string:url)!))
    }

    public class func GET(url:String, query:[String:String]) -> Promise<UIImage> {
        return promise(OMGHTTPURLRQ.GET(url, query))
    }

    public class func POST(url:String, formData:[String:String]) -> Promise<UIImage> {
        return promise(OMGHTTPURLRQ.POST(url, formData))
    }

    public class func POST(url:String, JSON json:[String:String]) -> Promise<UIImage> {
        return promise(OMGHTTPURLRQ.POST(url, JSON: json))
    }

    public class func POST(url:String, multipartFormData: OMGMultipartFormData) -> Promise<UIImage> {
        return promise(OMGHTTPURLRQ.POST(url, multipartFormData))
    }

    public class func promise(rq: NSURLRequest) -> Promise<UIImage> {
        return fetch(rq) { (fulfiller, rejecter, data, _) in
            assert(!NSThread.isMainThread())

            var img = UIImage(data: data) as UIImage!
            if img != nil {
                img = UIImage(CGImage:img.CGImage, scale:img.scale, orientation:img.imageOrientation)
                if img != nil {
                    return fulfiller(img)
                }
            }

            let info = [NSLocalizedDescriptionKey: "The server returned invalid image data"]
            rejecter(NSError(domain:NSURLErrorDomain, code:NSURLErrorBadServerResponse, userInfo:info))
        }
    }
}
#endif
