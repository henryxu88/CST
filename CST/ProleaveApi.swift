//
//  ProleaveApi.swift
//  CST
//
//  Created by henry on 16/2/5.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class ProleaveApi {
    
    class func getProleaveDetail(keyId: String, resultClosure:((Bool,Proleave?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.PROLEAVE_DETAIL
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Proleave.parse(value)
                    let res = obj.result
                    if res.OK() {
                        resultClosure(true,obj)
                    } else {
                        print("code:\(res.errorCode) msg:\(res.errorMessage)")
                        resultClosure(false,nil)
                    }
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }
    
    class func createProleave(proleave: Proleave, resultClosure:((Bool) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["proinfoId"] = proleave.proInfoId
        parameters["strReason"] = proleave.reason
        parameters["strLeaveDate"] = proleave.leaveDate
        parameters["timestamp"] = proleave.timestamp
        
        let url = NetManager.PROLEAVE_CREATE
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Proleave.parse(value)
                    let res = obj.result
                    if res.OK() {
                        resultClosure(true)
                    } else {
                        print("code:\(res.errorCode) msg:\(res.errorMessage)")
                        resultClosure(false)
                    }
                }
            case .Failure(let error):
                print(error)
                resultClosure(false)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }
    
    class func initProleaveDetail(proinfoId: String, resultClosure:((Bool,Proleave?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["proinfoId"] = proinfoId

        let url = NetManager.PROLEAVE_INIT
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Proleave.parse(value)
                    let res = obj.result
                    if res.OK() {
                        resultClosure(true,obj)
                    } else {
                        print("code:\(res.errorCode) msg:\(res.errorMessage)")
                        resultClosure(false,nil)
                    }
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }

    
}
