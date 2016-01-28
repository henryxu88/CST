//
//  ProinfoList.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProinfoList: EntityList<Proinfo> {
    
    class func parse(dict: AnyObject) -> ProinfoList {
        let obj = ProinfoList()
        var result = Result()
        let json = JSON(dict)
//        print(json)
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            ProinfoList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: ProinfoList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var proinfo: Proinfo
            for subJson in array {
//                print(subJson)
                proinfo = Proinfo.parseListItem(subJson)
                if !proinfo.id.isEmpty {
                    obj.list.append(proinfo)
                }
            }
        }
        
    }
    
}