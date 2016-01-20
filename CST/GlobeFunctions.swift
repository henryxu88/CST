//
//  GlobeFunctions.swift
//  MyPass
//
//  Created by henry on 16/1/14.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit


extension UIViewController {
    /**
     显示Alert对话框
     
     - parameter msg: 要显示的消息
     */
    func displayMessage(msg: String){
        
        let alertController = UIAlertController(title: "警告", message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        
        alertController.addAction(action)
        
        presentViewController(alertController, animated: true, completion: nil)
    }

}


extension NSData {
    
    /// Return hexadecimal string representation of NSData bytes
    @objc(kdj_hexadecimalString)
    public var hexadecimalString: NSString {
        var bytes = [UInt8](count: length, repeatedValue: 0)
        getBytes(&bytes, length: length)
        
        let hexString = NSMutableString()
        for byte in bytes {
            hexString.appendFormat("%02x", UInt(byte))
        }
        
        return NSString(string: hexString)
    }
}