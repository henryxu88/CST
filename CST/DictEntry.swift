//
//  DictEntry.swift
//  CST
//
//  Created by henry on 16/2/26.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class DictEntry: Entity {
    
    // name
    private(set) var name = ""
    
    class func parse(json: JSON) -> DictEntry {
        let obj = DictEntry()
        obj.id = json["id"].stringValue
        obj.name = json["name"].stringValue
        return obj
    }
    
}