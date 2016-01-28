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
    
    
    
}