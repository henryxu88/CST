//
//  Entity.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Entity: Base {
    
    var timestamp = ""
    var result = Result()     //返回的结果
    
    var id = ""
    var createDate = ""
    var modifyDate = ""
    
    var createrId = ""
    var createrName = ""
    var createrFace = ""
    
    var cacheKey = ""
    var cacheDate = ""
    
    class func parseResult(dict: AnyObject) -> Entity {
        let obj = Entity()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        
        obj.result = result
        return obj
    }
}