//
//  UserApi.swift
//  CST
//
//  Created by henry on 16/2/19.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class UserApi {
    
    class func authc(username: String,digest: String,resultClosure:((Bool,User?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["u"] = username
        parameters["digest"] = digest
        
        let url = NetManager.BASE_PATH + NetManager.URL_AUTOLOGIN //+ "?u=" + username + "&digest=" + digest
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let user = User.parse(value)
                    resultClosure(true,user)
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        Alamofire.request(.POST, url ,parameters: parameters).validate().responseJSON(completionHandler: urlHandler)
        
    }
    
    class func loginWithDeviceId(username: String,password: String,deviceId: String, resultClosure:((Bool,User?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["username"] = username
        parameters["password"] = password
        parameters["deviceId"] = deviceId
        
        let url = NetManager.BASE_PATH + NetManager.URL_LOGIN
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let user = User.parse(value)
                    resultClosure(true,user)
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        Alamofire.request(.POST, url ,parameters: parameters).validate().responseJSON(completionHandler: urlHandler)
        
    }

    class func getUserList(catalog: Int, pageIndex: Int, property: String, keyword: String, resultClosure:((Bool,[UserEasyView]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 13
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = NetManager.pageSize * 10 // 200
        parameters["pageProperty"] = property       // "name"
        parameters["pageKeyword"] = keyword
        
        let url = NetManager.USER_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let userViewList = UserViewList.parse(value)
                    let res = userViewList.result
                    if res.OK() {
                        let objs = userViewList.list
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