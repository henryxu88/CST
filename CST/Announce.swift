//
//  Announce.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Announce: Entity {
    // 主题
    private(set) var name = ""
    // 发布时间
    private(set) var publishTime = ""
    // 公告内容
    private(set) var content = ""
    // 通知方式：全部：0 部分人员：1
    private(set) var callType = ""
    // 通知人员
    private(set) var usersSet = ""

    class func parse(dict: AnyObject) -> Announce {
        let obj = Announce()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Announce.parse(json["data"],obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Announce) {
        
        obj.id = json["id"].stringValue
        
        obj.name = json["name"].stringValue
        obj.publishTime = json["publishTime"].stringValue
        
        obj.content = json["content"].stringValue
        obj.callType = json["callType"].stringValue
        obj.usersSet = json["usersSet"].stringValue

    }

}