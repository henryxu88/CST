//
//  ProbackList.swift
//  CST
//
//  Created by henry on 16/2/2.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProbackList: EntityList<Proback> {
    
    class func parse(dict: AnyObject) -> ProbackList {
        let obj = ProbackList()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            ProbackList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: ProbackList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var proback: Proback
            for subJson in array {
                proback = Proback.parseListItem(subJson)
                if !proback.id.isEmpty {
                    obj.list.append(proback)
                }
            }
        }
        
    }
    
}