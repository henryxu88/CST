//
//  CalendarEventList.swift
//  CST
//
//  Created by henry on 16/2/4.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class CalendarEventList: EntityList<CalendarEvent> {
    
    class func parse(dict: AnyObject) -> CalendarEventList {
        let obj = CalendarEventList()
        var result = Result()
        let json = JSON(dict)
        //        print(json)
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            CalendarEventList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: CalendarEventList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var calendarEvent: CalendarEvent
            for subJson in array {
                //                print(subJson)
                calendarEvent = CalendarEvent.parseListItem(subJson)
                if !calendarEvent.id.isEmpty {
                    obj.list.append(calendarEvent)
                }
            }
        }
        
    }
    
}