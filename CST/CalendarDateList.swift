//
//  CalendarDateList.swift
//  CST
//
//  Created by henry on 16/2/5.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class CalendarDateList: EntityList<CalendarDate> {
    
    class func parse(dict: AnyObject) -> CalendarDateList {
        let obj = CalendarDateList()
        var result = Result()
        let json = JSON(dict)
        //        print(json)
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            CalendarDateList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: CalendarDateList) -> Void {
        
        let array = json["dateList"].arrayValue
        if !array.isEmpty {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var calendarDate: CalendarDate
            for subJson in array {
                calendarDate = CalendarDate()
                calendarDate.date = dateFormatter.dateFromString(subJson.stringValue)
//                calendarDate.date = subJson.stringValue
                obj.list.append(calendarDate)
            }
        }
        
    }
    
}