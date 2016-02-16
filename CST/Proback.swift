//
//  Proback.swift
//  CST
//
//  Created by henry on 16/2/2.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON

class Proback: Entity {
    // 项目Id
    private(set) var projectId = ""
    // 项目名称
    private(set) var name = ""
    // 反馈类别
    private(set) var categoryId = ""
    private(set) var categoryName = ""
    // 反馈日期
    private(set) var backDate = ""
    // 反馈内容
    private(set) var content = ""
    // 备注
    private(set) var mark = ""
    // 是否正常 1:正常 0:不正常
    private(set) var regular = "0"
    // 签到地址
    private(set) var address = ""
    // 纬度
    private(set) var latitude = ""
    // 经度
    private(set) var longitude = ""
    // 对应的location对象的Id
    private(set) var locationId = ""
    // 通知人员
    private(set) var noticemanIds = ""
    private(set) var noticeMen = [UserEasyView]()
    
    // 图片列表
//    private(set) var photoListIds = ""
    private(set) var photoList = [String]()
    
    // 图片数量
    private(set) var picAmount = ""

    // 是否有反馈履历 1:有 0:暂无
    private(set) var hasResume = "0"
    
    class func parse(dict: AnyObject) -> Proback {
        let obj = Proback()
        var result = Result()
        let json = JSON(dict)
        
        if !json["result"].isEmpty {
            result = Result.parse(json["result"])
        }
        if !json["data"].isEmpty {
            Proback.parse(json["data"], obj: obj)
        }
        obj.result = result
        return obj
    }
    
    class func parse(json: JSON, obj: Proback) {
        
        obj.id = json["id"].stringValue
        obj.createDate = json["createDate"].stringValue
        obj.modifyDate = json["modifyDate"].stringValue
        
        obj.createrId = json["createrId"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        obj.projectId = json["projectId"].stringValue
        obj.name = json["name"].stringValue
        
        obj.categoryId = json["categoryId"].stringValue
        obj.categoryName = json["categoryName"].stringValue
        
        obj.backDate = json["backDate"].stringValue
        obj.content = json["content"].stringValue
        
        obj.address = json["address"].stringValue
        obj.locationId = json["locationId"].stringValue

        obj.mark = json["mark"].stringValue
        
        obj.regular = json["regular"].stringValue
        obj.hasResume = json["hasResume"].stringValue
        
        var array = json["noticeMan"].arrayValue
        if !array.isEmpty {
            var objs = [UserEasyView]()
            for subJson in array {
                // print(subJson)
                if !subJson.isEmpty {
                    objs.append(UserEasyView.parse(subJson))
                }
            }
            obj.noticeMen = objs
        }

        array = json["photoList"].arrayValue
        if !array.isEmpty {
            var objs = [String]()
            for subJson in array {
                if !subJson.stringValue.isEmpty {
                    objs.append(NetManager.FILE_PUBLIC + "?gridId=" + subJson.stringValue)
                }
            }
            obj.photoList = objs
        }
        
    }
    
    class func parseListItem(json: JSON) -> Proback {
        let obj = Proback()
        
        obj.id = json["id"].stringValue
        
        obj.name = json["name"].stringValue
        
        obj.categoryName = json["categoryName"].stringValue
        obj.backDate = json["backDate"].stringValue
        obj.content = json["content"].stringValue
        obj.regular = json["regular"].stringValue
        obj.createrName = json["createrName"].stringValue
        
        return obj
    }
}