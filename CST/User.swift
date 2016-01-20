//
//  User.swift
//  CST
//
//  Created by henry on 16/1/19.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import SwiftyJSON
import CryptoSwift

class User {
    
    private(set) var username = ""      //本系统中就是手机号
    private(set) var salt = ""          //盐值
    private(set) var digest = ""        //对密码进行MD5加密后的摘要
    
    private(set) var id = ""             //sys_users表中的id
    private(set) var createDate = ""
    private(set) var modifyDate = ""
    
    private(set) var aid = ""            //sys_admin表中的id
    
    var name = ""
    var pinYin = ""
    var pinYinHead = ""
    
    var companyId = ""
    var companyName = ""
    var companySubName = ""
    var departmentId = ""
    var departmentName = ""
    
    class func parse(json: JSON, username: String) -> User {
        let user = User()
        
        user.username = username
        
        user.salt = json["salt"].stringValue
        
        user.id = json["id"].stringValue
        user.createDate = json["createDate"].stringValue
        user.modifyDate = json["modifyDate"].stringValue
        
        user.aid = json["aid"].stringValue
        
        user.name = json["name"].stringValue
        user.pinYin = json["pinYin"].stringValue
        user.pinYinHead = json["pinYinHead"].stringValue
        
        user.companyId = json["companyId"].stringValue
        user.companyName = json["companyName"].stringValue
        user.companySubName = json["companySubName"].stringValue
        user.departmentId = json["departmentId"].stringValue
        user.departmentName = json["departmentName"].stringValue
        
        //根据"uid":aid , "u":username , 生成HMAC（Hash-based Message Authentication Code）：基于散列的消息认证码
        let content = user.aid + username
        user.digest = User.digestWith(user.salt, AndContent: content)
        
        return user
    }
    
    private class func digestWith(key: String, AndContent content: String) -> String {
        var keyBuff = [UInt8]()
        keyBuff += key.utf8
        
        var msgBuff = [UInt8]()
        msgBuff += content.utf8
        do {
            let hmac = try Authenticator.HMAC(key: keyBuff, variant: .sha256).authenticate(msgBuff)
            let digestStr = NSData.withBytes(hmac).hexadecimalString as String
//            print("digest: \(digestStr)")
            return digestStr
        } catch let err as NSError {
            print("digest err: " + err.localizedDescription)
            return ""
        }
    }
}