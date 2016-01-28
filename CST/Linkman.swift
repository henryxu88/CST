//
//  Linkman.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Linkman: Entity {
    // 客户
    private(set) var clientId = ""
    private(set) var clientName = ""
    // 姓名
    private(set) var name = ""
    // 常用称呼
    private(set) var subName = ""
    // 职位
    private(set) var duty = ""
    // 办公电话
    private(set) var tel = ""
    // 手机
    private(set) var mobile = ""
    // 备用手机
    private(set) var mobile_back = ""
    // 邮箱
    private(set) var email = ""
    // 生日(yyyy-MM-dd)
    private(set) var birthday = ""
    // 个人喜好
    private(set) var preferences = ""
    // 备注
    private(set) var remark = ""
    
    
    class func parse(dict: AnyObject) -> Linkman {
        var obj = Linkman()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            obj = Linkman.parse(json["data"])
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON) -> Linkman {
        let obj = Linkman()
        
        obj.id = json["id"].stringValue
        obj.clientId = json["clientId"].stringValue
        obj.clientName = json["clientName"].stringValue
        
        obj.name = json["name"].stringValue
        obj.subName = json["subName"].stringValue
        
        obj.duty = json["duty"].stringValue
        obj.mobile = json["mobile"].stringValue
        obj.mobile_back = json["mobile_back"].stringValue
        obj.tel = json["tel"].stringValue
        
        obj.email = json["email"].stringValue
        obj.preferences = json["preferences"].stringValue
        obj.birthday = json["birthday"].stringValue
        
        obj.remark = json["remark"].stringValue
        
        return obj
    }

}