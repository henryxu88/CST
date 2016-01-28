//
//  ClientList.swift
//  CST
//
//  Created by henry on 16/1/28.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class ClientList: EntityList<Client> {
    
    class func parse(dict: AnyObject) -> ClientList {
        let obj = ClientList()
        var result = Result()
        let json = JSON(dict)
        //        print(json)
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            ClientList.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: ClientList) -> Void {
        
        obj.pageNum = json["pageNum"].intValue
        obj.pageSize = json["pageSize"].intValue
        obj.pageCount = json["pageCount"].intValue
        obj.totalCount = json["totalCount"].intValue
        
        let array = json["dataRows"].arrayValue
        if !array.isEmpty {
            var client: Client
            for subJson in array {
                //                print(subJson)
                client = Client.parseListItem(subJson)
                if !client.id.isEmpty {
                    obj.list.append(client)
                }
            }
        }
        
    }
    
}