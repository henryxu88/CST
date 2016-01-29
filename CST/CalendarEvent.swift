//
//  CalendarEvent.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

/// 日历事件（签到＋请假）
class CalendarEvent: Entity {
    var name = ""
    var remark = ""
    var startTime = ""
    var endTime = ""
    var type = ""
    
    class func parse(dict: AnyObject) -> CalendarEvent {
        let obj = CalendarEvent()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            CalendarEvent.parse(json["data"],obj:obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: CalendarEvent) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        obj.modifyDate = json["modifyDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        obj.name = json["name"].stringValue
        obj.remark = json["remark"].stringValue
        
        obj.startTime = json["time"].stringValue
        obj.endTime = json["endtime"].stringValue
        obj.type = json["type"].stringValue
        
    }
}