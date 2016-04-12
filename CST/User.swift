//
//  User.swift
//  CST
//
//  Created by henry on 16/1/19.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON
import CryptoSwift

class User: NameEntity {
    
    var username = ""      //本系统中就是手机号
    private(set) var isRememberMe = true
    
    private(set) var aid = ""            //sys_admin表中的id
    private(set) var salt = ""          //盐值
    var digest = ""        //对密码进行MD5加密后的摘要
    
    //公司信息
    private(set) var companyId = ""
    private(set) var companyName = ""
    private(set) var companySubName = ""
    //部门信息
    private(set) var departmentId = ""
    private(set) var departmentName = ""
    
    class func parse(dict: AnyObject) -> User {
        let user = User()
        var result = Result()
        let json = JSON(dict)

        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            User.parse(json["data"],user: user)
        }
        user.result = result
        return user
    }
    
    class func parse(json: JSON, user: User) {
        
        user.salt = json["salt"].stringValue
        
        user.id = json["id"].stringValue
        user.createDate = json["createDate"].stringValue
        user.modifyDate = json["modifyDate"].stringValue
        
        user.aid = json["aid"].stringValue
        
        user.name = json["name"].stringValue
        user.pinYin = json["pinYin"].stringValue
        user.pinYinHead = json["pinYinHead"].stringValue
        
        user.companyId = json["companyId"].stringValue
        user.companyName = json["companyName"].stringValue
        user.companySubName = json["companySubName"].stringValue
        user.departmentId = json["departmentId"].stringValue
        user.departmentName = json["departmentName"].stringValue
        
    }

}