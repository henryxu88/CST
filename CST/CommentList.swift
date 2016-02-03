//
//  CommentList.swift
//  CST
//
//  Created by henry on 16/2/3.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class CommentList: EntityList<Comment> {
    
    class func parse(dict: AnyObject) -> CommentList {
        let obj = CommentList()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            CommentList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: CommentList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var comment: Comment
            for subJson in array {
                comment = Comment.parseListItem(subJson)
                if !comment.id.isEmpty {
                    obj.list.append(comment)
                }
            }
        }
        
    }
    
}