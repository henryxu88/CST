//
//  DictEntryList.swift
//  CST
//
//  Created by henry on 16/2/26.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class DictEntryList: EntityList<DictEntry> {
    
    // 系统字典的关键字：如 ProBackCategory
    private(set) var keyWord = ""
    
    class func parse(dict: AnyObject) -> DictEntryList {
        let obj = DictEntryList()
        var result = Result()
        let json = JSON(dict)
        //        print(json)
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            DictEntryList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: DictEntryList) -> Void {
        obj.keyWord = json["keyWord"].stringValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            
            var dictEntry: DictEntry
            for subJson in array {
                dictEntry = DictEntry.parse(subJson)
                if !dictEntry.id.isEmpty {
                    obj.list.append(dictEntry)
                }
            }
        }
        
    }
    
}