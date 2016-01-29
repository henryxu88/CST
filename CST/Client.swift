//
//  Client.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Client: Entity {
    // 客户名称
    private(set) var name = ""
    // 客户简称
    private(set) var subName = ""
    // 客户性质
    private(set) var typeName = ""
    // 地址
    private(set) var province = ""
    private(set) var city = ""
    private(set) var county = ""
    // 发票抬头
    private(set) var invoiceTitle = ""
    // 备注
    private(set) var remark = ""
    // 客户情况说明
    private(set) var situtation = ""
    
    class func parse(dict: AnyObject) -> Client {
        let obj = Client()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Client.parse(json["data"],obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Client) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        obj.modifyDate = json["modifyDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        obj.name = json["name"].stringValue
        
        obj.subName = json["subName"].stringValue
        obj.typeName = json["typeName"].stringValue
        obj.invoiceTitle = json["invoiceTitle"].stringValue
        
        obj.province = json["province"].stringValue
        obj.city = json["city"].stringValue
        obj.county = json["county"].stringValue
        
        obj.situtation = json["situtation"].stringValue
        obj.remark = json["remark"].stringValue

    }
    
    class func parseListItem(json: JSON) -> Client {
        let obj = Client()
        
        obj.id = json["id"].stringValue
        
        obj.name = json["name"].stringValue
        
        obj.typeName = json["typeName"].stringValue
        
        return obj
    }

}
