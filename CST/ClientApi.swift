//
//  ClientApi.swift
//  CST
//
//  Created by henry on 16/1/28.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class ClientApi {
    
    class func getClientList(catalog: Int, pageIndex: Int, property: String, keyword: String, resultClosure:((Bool,[Client]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 1
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize // 20
        parameters["pageProperty"] = property       // "name"
        parameters["pageKeyword"] = keyword
        
        let url = NetManager.CLIENT_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let clientList = ClientList.parse(value)
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
    
}