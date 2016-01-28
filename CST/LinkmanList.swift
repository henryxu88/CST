//
//  LinkmanList.swift
//  CST
//
//  Created by henry on 16/1/28.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class LinkmanList: EntityList<Linkman> {
    
    class func parse(dict: AnyObject) -> LinkmanList {
        let obj = LinkmanList()
        var result = Result()
        let json = JSON(dict)
        //        print(json)
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            LinkmanList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: LinkmanList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var linkman: Linkman
            for subJson in array {
                //                print(subJson)
                linkman = Linkman.parseListItem(subJson)
                if !linkman.id.isEmpty {
                    obj.list.append(linkman)
                }
            }
        }
        
    }

}