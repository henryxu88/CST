//
//  LinkmanApi.swift
//  CST
//
//  Created by henry on 16/1/29.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class LinkmanApi {
    
    class func getLinkmanList(catalog: Int, pageIndex: Int, property: String, keyword: String, resultClosure:((Bool,[Linkman]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 2
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize // 20
        parameters["pageProperty"] = property       // "name"
        parameters["pageKeyword"] = keyword
        
        let url = NetManager.LINKMAN_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let clientList = LinkmanList.parse(value)
                    let res = clientList.result
                    if res.OK() {
                        let objs = clientList.list
                        //                            print("objs.count: \(objs.count)")
                        if objs.count == 0 {
                            resultClosure(true,nil)
                        } else {
                            resultClosure(true,objs)
                        }
                        
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
    
    class func getLinkmanDetail(keyId: String, resultClosure:((Bool,Linkman?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.LINKMAN_DETAIL
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Linkman.parse(value)
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