//
//  CryptoUtils.swift
//  CST
//
//  Created by henry on 16/1/27.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import CryptoSwift

class CrypoUtils {
    
    /**
     HMAC SHA 256 加密
     
     - parameter key:     关键字
     - parameter content: 加密内容
     
     - returns: 加密好的摘要
     */
    class func digestWith(key: String, AndContent content: String) -> String {
        var keyBuff = [UInt8]()
        keyBuff += key.utf8
        
        var msgBuff = [UInt8]()
        msgBuff += content.utf8
        do {
            let hmac = try Authenticator.HMAC(key: keyBuff, variant: .sha256).authenticate(msgBuff)
            let digestStr = NSData.withBytes(hmac).hexadecimalString as String
            // print("digest: \(digestStr)")
            return digestStr
        } catch let err as NSError {
            print("digest err: " + err.localizedDescription)
            return ""
        }
    }
    
}