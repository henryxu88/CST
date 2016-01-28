//
//  Result.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Result: Base {
    
    private(set) var errorCode = ""
    private(set) var errorMessage = ""
    
    func OK() -> Bool {
        return errorCode == "1"
    }
    
    class func parse(jsonObject: JSON) -> Result {
        let result = Result()
        
        result.errorCode = jsonObject["errorCode"].stringValue ?? "0"
        result.errorMessage = jsonObject["errorMessage"].string ?? ""
        
        return result
    }
    
    class func parse(stringObject: String) -> Result {
        let jsonObject = JSON(stringObject)
        let result = parse(jsonObject)
        return result
    }
    
}