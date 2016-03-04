//
//  ProsigninApi.swift
//  CST
//
//  Created by henry on 16/2/5.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class ProsigninApi {
    
    class func getProsigninDetail(keyId: String, resultClosure:((Bool,Prosignin?) -> Void)) {
        var parameters = [String:AnyObject]()
        parameters["keyId"] = keyId
        
        let url = NetManager.PROSIGNIN_DETAIL
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let obj = Prosignin.parse(value)
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
