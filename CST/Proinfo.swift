//
//  Proinfo.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Proinfo: Entity {
    // 项目类别
    private(set) var categoryId = ""
    private(set) var categoryName = ""
    // 客户
    private(set) var clientId = ""
    private(set) var clientName = ""
    // 项目名称
    private(set) var name = ""
    // 联系人
    private(set) var linkmanId = ""
    private(set) var linkmanName = ""
    // 地址
    private(set) var province = ""
    private(set) var city = ""
    private(set) var county = ""
    private(set) var address = ""
    // 总监
    private(set) var chief = ""
    // 项目组成员
    private(set) var group = ""
    // 启动时间
    private(set) var start = ""
    // 结束时间
    private(set) var end = ""
    
    class func parse(dict: AnyObject) -> Proinfo {
        let obj = Proinfo()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Proinfo.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Proinfo) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        obj.modifyDate = json["modifyDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        obj.name = json["name"].stringValue
        
        obj.clientId = json["clientId"].stringValue
        obj.clientName = json["clientName"].stringValue
        
        obj.categoryId = json["categoryId"].stringValue
        obj.categoryName = json["categoryName"].stringValue
        
        obj.linkmanId = json["linkmanId"].stringValue
        obj.linkmanName = json["linkmanName"].stringValue
        
        obj.province = json["province"].stringValue
        obj.city = json["city"].stringValue
        obj.county = json["county"].stringValue
        obj.address = json["address"].stringValue
        
        obj.chief = json["chief"].stringValue
        obj.group = json["group"].stringValue
        
        obj.start = json["start"].stringValue
        obj.end = json["end"].stringValue
        
    }
    
    class func parseListItem(json: JSON) -> Proinfo {
        let obj = Proinfo()
        
        obj.id = json["id"].stringValue
        
        obj.name = json["name"].stringValue
        
        obj.chief = json["chief"].stringValue
        
        return obj
    }
}