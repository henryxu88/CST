//
//  CalendarEventApi.swift
//  CST
//
//  Created by henry on 16/2/4.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Alamofire

class CalendarEventApi {
    
    class func getCalendarEventList(catalog: Int, pageIndex: Int, proinfoId: String = "", startTime: Int64 = 0, endTime: Int64 = 0,resultClosure:((Bool,[CalendarEvent]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 272
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = 200 // NetManager.pageSize
        parameters["proinfoId"] = proinfoId
        parameters["_startTime"] = "\(startTime)"
        parameters["_endTime"] = "\(endTime)"
        
        let url = NetManager.CALENDAR_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let calendarEventList = CalendarEventList.parse(value)
                    let res = calendarEventList.result
                    if res.OK() {
                        let objs = calendarEventList.list

                        if objs.count == 0 {
                            resultClosure(true,nil)
                        } else {
                            resultClosure(true,objs)
                        }
                        
                    } else {
                        print("code:\(res.errorCode) msg:\(res.errorMessage)")
                        resultClosure(false,nil)
                    }
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }
    
    class func getEventDateList(catalog: Int, pageIndex: Int, proinfoId: String = "", startTime: Int64 = 0, endTime: Int64 = 0,resultClosure:((Bool,[CalendarDate]?) -> Void)){
        
        var parameters = [String:AnyObject]()
        
        parameters["catalog"] = catalog // 272
        parameters["pageIndex"] = pageIndex // 1
        parameters["pageSize"] = 40 // 最多31天
        parameters["proinfoId"] = proinfoId
        parameters["_startTime"] = "\(startTime)"
        parameters["_endTime"] = "\(endTime)"
        
        let url = NetManager.CALENDAR_DATE_LIST
        
        let urlHandler = {(response: Response<AnyObject, NSError>) -> Void in
            switch response.result {
            case .Success:
//                print("result:\(response.result.value)")
                if let value = response.result.value {
                    let calendarDateList = CalendarDateList.parse(value)
                    let res = calendarDateList.result
                    if res.OK() {
                        let objs = calendarDateList.list
                        
                        if objs.count == 0 {
                            resultClosure(true,nil)
                        } else {
                            resultClosure(true,objs)
                        }
                        
                    } else {
                        print("code:\(res.errorCode) msg:\(res.errorMessage)")
                        resultClosure(false,nil)
                    }
                }
            case .Failure(let error):
                print(error)
                resultClosure(false,nil)
            }
        }
        
        BaseApi.postResult(url, parameters: parameters, handler: urlHandler)
    }
    
}