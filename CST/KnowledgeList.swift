//
//  KnowledgeList.swift
//  CST
//
//  Created by henry on 16/2/23.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class KnowledgeList: EntityList<Knowledge> {
    
    class func parse(dict: AnyObject) -> KnowledgeList {
        let obj = KnowledgeList()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            KnowledgeList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: KnowledgeList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var knowledge: Knowledge
            for subJson in array {
                knowledge = Knowledge.parseListItem(subJson)
                if !knowledge.id.isEmpty {
                    obj.list.append(knowledge)
                }
            }
        }
        
    }
    
}
