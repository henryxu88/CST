//
//  ResumeList.swift
//  CST
//
//  Created by henry on 16/2/24.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class ResumeList: EntityList<Resume> {
    
    class func parse(dict: AnyObject) -> ResumeList {
        let obj = ResumeList()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            ResumeList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: ResumeList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var resume: Resume
            for subJson in array {
                resume = Resume.parseListItem(subJson)
                if !resume.id.isEmpty {
                    obj.list.append(resume)
                }
            }
        }
        
    }
    
}
