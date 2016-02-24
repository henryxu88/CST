//
//  KnowledgeApi.swift
//  CST
//
//  Created by henry on 16/2/23.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class KnowledgeApi {
    
    class func getKnowledgeList(catalog: Int, pageIndex: Int, property: String = "", keyword: String = "", resultClosure:((Bool,[Knowledge]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 8
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize // 20
        parameters["pageProperty"] = property       // "name"
        parameters["pageKeyword"] = keyword
        
        let url: String = NetManager.KNOWLEDGE_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let list = KnowledgeList.parse(value)
                    let res = list.result
                    if res.OK() {
                        let objs = list.list
                        
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
    
    class func getKnowledgeDetail(keyId: String, resultClosure:((Bool,Knowledge?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.KNOWLEDGE_DETAIL
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Knowledge.parse(value)
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
    
    class func getFileViewUrl(keyId: String, resultClosure:((Bool,String?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.KNOWLEDGE_FILEVIEW
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Entity.parseResult(value)
                    let res = obj.result
                    if res.OK() {
                        resultClosure(true,res.errorMessage)
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
