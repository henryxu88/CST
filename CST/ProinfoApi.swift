//
//  ProinfoApi.swift
//  CST
//
//  Created by henry on 16/1/28.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class ProinfoApi {
    
    class func getProinfoList(catalog: ProinfoCatalog, pageIndex: Int, property: String, keyword: String, resultClosure:((Bool,[Proinfo]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["pageIndex"] = pageIndex
        parameters["pageSize"] = NetManager.pageSize
        parameters["pageProperty"] = property
        parameters["pageKeyword"] = keyword
        
        var url: String
        if catalog == ProinfoCatalog.PrjsRelated {
            url = NetManager.PROINFO_LIST_RELATED
        } else {
            url = NetManager.PROINFO_LIST
            if catalog == ProinfoCatalog.PrjsNotFinish {
                parameters["catalog"] = 1
            } else if catalog == ProinfoCatalog.PrjsFinished {
                parameters["catalog"] = 2
            }
        }
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let proinfoList = ProinfoList.parse(value)
                        let res = proinfoList.result
                        if res.OK() {
                            let objs = proinfoList.list
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
    
    class func getProinfoDetail(keyId: String, resultClosure:((Bool,Proinfo?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.PROINFO_DETAIL
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Proinfo.parse(value)
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
    
    class func assign(keyId: String, address: String, latitude: String, longitude: String, resultClosure:((Bool, Result?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        parameters["addressSignin"] = address
        parameters["latitude"] = latitude
        parameters["longitude"] = longitude
        
        let url = NetManager.PROINFO_ASSIGN
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Entity.parseResult(value)
                    let res = obj.result
                    resultClosure(true,res)
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }

    
}