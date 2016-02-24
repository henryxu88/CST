//
//  Knowledge.swift
//  CST
//
//  Created by henry on 16/2/23.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Knowledge: Entity {
    // 主题
    private(set) var name = ""
    // 知识大类
    private(set) var superType = ""
    // 知识小类
    private(set) var subType = ""
    // 知识内容
    private(set) var context = ""
    // 知识内容html
    private(set) var contextHtml = ""
    // 文件上传
    private(set) var knowledgeId = ""
    
    class func parse(dict: AnyObject) -> Knowledge {
        let obj = Knowledge()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Knowledge.parse(json["data"],obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Knowledge) {
        
        obj.id = json["id"].stringValue
        
        obj.name = json["name"].stringValue
        obj.superType = json["superType"].stringValue
        obj.subType = json["subType"].stringValue
        obj.context = json["context"].stringValue
        obj.contextHtml = json["contextHtml"].stringValue
        obj.knowledgeId = json["knowledgeId"].stringValue
    }
    
    class func parseListItem(json: JSON) -> Knowledge {
        let obj = Knowledge()
        
        obj.id = json["id"].stringValue
        
        obj.name = json["name"].stringValue
        
        obj.superType = json["superType"].stringValue
        obj.subType = json["subType"].stringValue
                
        return obj
    }
    
}