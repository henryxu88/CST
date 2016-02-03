//
//  AnnounceList.swift
//  CST
//
//  Created by henry on 16/2/1.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class AnnounceList: EntityList<Announce> {
    
    class func parse(dict: AnyObject) -> AnnounceList {
        let obj = AnnounceList()
        var result = Result()
        let json = JSON(dict)

        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            AnnounceList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: AnnounceList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var announce: Announce
            for subJson in array {
                announce = Announce.parseListItem(subJson)
                if !announce.id.isEmpty {
                    obj.list.append(announce)
                }
            }
        }
        
    }
    
}
