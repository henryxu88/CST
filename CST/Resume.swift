//
//  Resume.swift
//  CST
//
//  Created by henry on 16/2/24.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Resume: Entity {
    
    // 操作人姓名
    private(set) var bizerName = ""
    // 操作内容
    private(set) var textObject = ""
    // 事件时间
    private(set) var eventDate = ""
    
    
    class func parse(dict: AnyObject) -> Resume {
        let obj = Resume()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Resume.parse(json["data"],obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Resume) {
        
        obj.id = json["id"].stringValue
        obj.eventDate = json["eventDate"].stringValue
        obj.textObject = json["textObject"].stringValue
        obj.bizerName = json["bizerName"].stringValue
        
    }
    
    class func parseListItem(json: JSON) -> Resume {
        let obj = Resume()
        
        obj.id = json["id"].stringValue
        obj.eventDate = json["eventDate"].stringValue
        obj.textObject = json["textObject"].stringValue
        obj.bizerName = json["bizerName"].stringValue
        
        return obj
    }
    
}