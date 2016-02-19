//
//  Comment.swift
//  CST
//
//  Created by henry on 16/2/3.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Comment: Entity {
    // 主题
    private(set) var subject = "无主题"
    // 项目名称
    private(set) var name = "无项目"
    // 类别：proinfo, proback, knowledge, announce
    private(set) var type = ""
    
    // @的用户成员
    var atUsers = ""   // userId1,userId2
    var atUsersName = ""   // @Name1,@Name2
    // 批注内容
    var text = ""
    
    // 被批注的文档Id
    var targetId = ""
    // 被批注的文档Class
    var targetClass = ""
    
    class func parse(dict: AnyObject) -> Comment {
        let obj = Comment()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Comment.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Comment) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        obj.modifyDate = json["modifyDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        if !json["createrFace"].stringValue.isEmpty {
            obj.createrFace = NetManager.FILE_PUBLIC + "?keyId=" + json["createrFace"].stringValue
        }
        
        
        obj.subject = json["subject"].stringValue
        obj.name = json["name"].stringValue
        obj.type = json["type"].stringValue
        
        obj.atUsersName = json["atUsersName"].stringValue
        obj.text = json["text"].stringValue
        
        
        obj.targetId = json["targetId"].stringValue
        obj.targetClass = json["targetClass"].stringValue
        
    }
    
    class func parseListItem(json: JSON) -> Comment {
        let obj = Comment()
        
        parse(json, obj: obj)
        
        return obj
    }
    
}