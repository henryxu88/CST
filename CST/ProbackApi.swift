//
//  ProbackApi.swift
//  CST
//
//  Created by henry on 16/2/2.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class ProbackApi {
    
    class func getProbackList(catalog: Int, pageIndex: Int, property: String = "", keyword: String = "", proinfoId: String = "" ,resultClosure:((Bool,[Proback]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 5:所有反馈 9:某一项目下的反馈 13:和我有关的反馈
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize // 20
        parameters["pageProperty"] = property       // "name"
        parameters["pageKeyword"] = keyword
        
        var url: String
        if catalog == 13 {
            url = NetManager.PROBACK_LIST_ABOUTME
        } else {
            if proinfoId.isEmpty {
                url = NetManager.PROBACK_LIST
            } else {
                parameters["proinfoId"] = proinfoId
                url = NetManager.PROBACK_LIST_PROINFO
            }
        }
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let probackList = ProbackList.parse(value)
                    let res = probackList.result
                    if res.OK() {
                        let objs = probackList.list
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
    
    class func getProbackDetail(keyId: String, resultClosure:((Bool,Proback?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.PROBACK_DETAIL
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Proback.parse(value)
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
    
    // 上传反馈图片
    
    // 初始化项目反馈
    
    // 创建项目反馈
}