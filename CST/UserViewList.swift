//
//  UserViewList.swift
//  CST
//
//  Created by henry on 16/2/19.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserViewList: EntityList<UserEasyView> {

    class func parse(dict: AnyObject) -> UserViewList {
        let obj = UserViewList()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            UserViewList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: UserViewList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var userEasyView: UserEasyView
            for subJson in array {
                userEasyView = UserEasyView.parse(subJson)
                if !userEasyView.id.isEmpty {
                    obj.list.append(userEasyView)
                }
            }
        }
        
    }
    
}