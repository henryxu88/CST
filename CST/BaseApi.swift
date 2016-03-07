//
//  BaseApi.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class BaseApi {
    
    
    class func getResult(let url: String, parameters:[String:AnyObject]?, handler:((Response<AnyObject, NSError>) -> Void)) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if !appDelegate.isLogin() {
            print("尚未登录或登录已过期，请重新登录")
            return
        }
        var requestUrl = getFullUrl(url)
        requestUrl += "?u=" + appDelegate.loginName + "&digest=" + appDelegate.loginDigest
        Alamofire.request(.GET, requestUrl ,parameters: parameters).validate().responseJSON(completionHandler: handler)
    }
    
    class func postResult(let url: String, parameters:[String:AnyObject]?, handler:((Response<AnyObject, NSError>) -> Void)) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if !appDelegate.isLogin() {
            print("尚未登录或登录已过期，请重新登录")
            return
        }
        var requestUrl = getFullUrl(url)
        requestUrl += "?u=" + appDelegate.loginName + "&digest=" + appDelegate.loginDigest
//        print("requestUrl: \(requestUrl)")
//        for (key, para) in parameters! {
//            print("key: \(key)  val: \(para)")
//        }
        Alamofire.request(.POST, requestUrl ,parameters: parameters).validate().responseJSON(completionHandler: handler)
    }
    
    class func getFullUrl(url: String) -> String {
        return NetManager.BASE_PATH + url
    }
    
    class func uploadResult(let url: String, keyId: String, data: NSData, handler:((Response<AnyObject, NSError>) -> Void)) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        if !appDelegate.isLogin() {
            print("尚未登录或登录已过期，请重新登录")
            return
        }
        var requestUrl = getFullUrl(url)
        requestUrl += "?u=" + appDelegate.loginName + "&digest=" + appDelegate.loginDigest + "&keyId=" + keyId
        
        let urlRequest = BaseApi.photoUrlRequestWithComponents(requestUrl, imageData: data)
        
        Alamofire.upload(urlRequest.0, data: urlRequest.1).responseJSON(completionHandler: handler)
//            .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
//                print("bytesRead:\(bytesRead) totalBytesRead:\(totalBytesRead) totalBytesExpectedToRead:\(totalBytesExpectedToRead)")
//            }
        
       
    }
    
    // this function creates the required URLRequestConvertible and NSData we need to use Alamofire.upload
    class func photoUrlRequestWithComponents(urlString:String, imageData:NSData) -> (URLRequestConvertible, NSData) {
        
        // create url request to send
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        mutableURLRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        let boundaryConstant = "myRandomBoundary12345";
        let contentType = "multipart/form-data;boundary="+boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        let uploadData = NSMutableData()
        
        // add image
        uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData("Content-Type: image/png\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        uploadData.appendData(imageData)
        uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // return URLRequestConvertible and NSData
        return (Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
    }
    
}