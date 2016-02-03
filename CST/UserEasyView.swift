//
//  UserEasyView.swift
//  CST
//
//  Created by henry on 16/2/2.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserEasyView: Base {
    
    private(set) var id = ""
    private(set) var uid = ""
    private(set) var name = ""
    
    class func parse(json: JSON) -> UserEasyView {
        let obj = UserEasyView()
        
        obj.id = json["id"].stringValue
        obj.uid = json["uid"].stringValue
        obj.name = json["name"].stringValue
    
        return obj
    }
    
    class func getIds(list: [UserEasyView]) -> [String] {
        var objs = [String]()
        
        if !list.isEmpty {
            for obj in list {
                objs.append(obj.id)
            }
        }
        
        return objs
    }
    
    class func getNames(list: [UserEasyView]) -> [String] {
        var objs = [String]()
        
        if !list.isEmpty {
            for obj in list {
                objs.append(obj.name)
            }
        }
        
        return objs
    }
    
}