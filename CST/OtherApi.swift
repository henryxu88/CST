//
//  OtherApi.swift
//  CST
//
//  Created by henry on 16/2/23.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class OtherApi {
    
    class func markRead(docId: String, resultClosure: (Bool) -> Void) {
        
        var parameters = [String:AnyObject]()
        
        parameters["docId"] = docId // 文档的ID
        
        let url = NetManager.MARK_DOC_READED
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let entity = Entity.parseResult(value)
                    let res = entity.result
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
    
    class func getResumeList(catalog: Int, pageIndex: Int, keyId: String, resultClosure:((Bool,[Resume]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 241
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize // 20
        parameters["keyId"] = keyId       // proback's id
        
        let url = NetManager.RESUME_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let resumeList = ResumeList.parse(value)
                    let res = resumeList.result
                    if res.OK() {
                        let objs = resumeList.list

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
    
}