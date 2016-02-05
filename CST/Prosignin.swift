//
//  Prosignin.swift
//  CST
//
//  Created by henry on 16/2/5.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Prosignin: Entity {
    // 项目信息
    private(set) var proInfoId = ""
    private(set) var proInfoName = ""
    private(set) var proInfoArea = ""
    private(set) var proInfoAddress = ""
    // 签到地址
    private(set) var address = ""
    // location
    private(set) var locationId = ""
    // 考勤状态：迟到：0 正常：1
    private(set) var status = ""
    
    class func parse(dict: AnyObject) -> Prosignin {
        let obj = Prosignin()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Prosignin.parse(json["data"],obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Prosignin) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        obj.proInfoId = json["proInfoId"].stringValue
        obj.proInfoName = json["proInfoName"].stringValue
        obj.proInfoArea = json["proInfoArea"].stringValue
        obj.proInfoAddress = json["proInfoAddress"].stringValue
        
        obj.address = json["address"].stringValue
        obj.status = json["status"].stringValue
    }
    
}