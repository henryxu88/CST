//
//  Proleave.swift
//  CST
//
//  Created by henry on 16/2/5.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Proleave: Entity {
    // 项目信息
    private(set) var proInfoId = ""
    private(set) var proInfoName = ""

    // 请假事由
    private(set) var reason = ""
    // 请假日期
    private(set) var leaveDate = ""

    
    class func parse(dict: AnyObject) -> Proleave {
        let obj = Proleave()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Proleave.parse(json["data"],obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Proleave) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        obj.proInfoId = json["proInfoId"].stringValue
        obj.proInfoName = json["proInfoName"].stringValue
        obj.reason = json["reason"].stringValue
        obj.leaveDate = json["leaveDate"].stringValue
        
    }
    
}