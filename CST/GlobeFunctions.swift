//
//  GlobeFunctions.swift
//  MyPass
//
//  Created by henry on 16/1/14.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController

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

    //MARK: - 设置系统菜单的显示／隐藏 -
    func setupLeftButton(){
        let btn = MMDrawerBarButtonItem.init(target: self, action: "hideMenuButtonTapped")
        btn.tintColor = UIColor.whiteColor()
        navigationItem.setLeftBarButtonItem(btn, animated: true)
    }
    
    func hideMenuButtonTapped() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    //MARK: - 设置返回主界面
    func setupRightButton(){
        let btn = MMDrawerBarButtonItem.init(target: self, action: "returnHomeButtonTapped")
        btn.image = UIImage(named: "tab_bar_user")
        btn.tintColor = UIColor.whiteColor()
        navigationItem.setRightBarButtonItem(btn, animated: true)
    }
    
    func returnHomeButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as? HomePageViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.setCenterViewController(main, withCloseAnimation: true, completion: nil)
    }
    
    //MARK: - 设置返回上一界面
    func setupReturnButton(){
        let btn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Reply, target: self, action: "returnButtonTapped")
        btn.tintColor = UIColor.whiteColor()
        navigationItem.setLeftBarButtonItem(btn, animated: true)
    }
    
    func returnButtonTapped() {
        dismissViewControllerAnimated(true, completion: nil)
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