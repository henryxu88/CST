//
//  ViewController.swift
//  CST
//
//  Created by henry on 16/1/15.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var userPwdTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        //手机号必填
        guard let userName = userNameTextField.text where !userName.isEmpty else {
            displayMessage("请输入手机号！")
            return
        }
        
        //密码必填
        guard let userPwd = userPwdTextField.text where !userPwd.isEmpty else {
            displayMessage("请输入密码！")
            return
        }
        
        //设备唯一码
        guard let deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString else {
            displayMessage("无法获取设备的唯一码！")
            return
        }
        
//        print("deviceId:" + deviceId)
        let url = URL_LOGIN
        let parameters = ["username": userName, "password": userPwd, "deviceId": deviceId]
        Alamofire.request(.POST, url ,parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)

                    let code = json["result"]["errorCode"].stringValue
                    if code != "1" {
                        let msg = json["result"]["errorMessage"].string ?? ""
                        self.displayMessage("错误信息：\(msg)")
                        return
                    } else {

                        let data = json["data"]
                        let user = User.parse(data, username: userName)
//                        print("user: \(user.name)")
                        
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        //记录登录账号
                        userDefaults.setObject(user.username, forKey: "loginName")
                        userDefaults.setObject(user.digest, forKey: "loginDigest")
                        userDefaults.setObject(user.id, forKey: "loginUid")
                        userDefaults.setObject(true, forKey: "login")
                        //记录是否曾经登录
                        userDefaults.setObject("yes", forKey: "hasLogged")

                        userDefaults.synchronize()
                        
                        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.currentUser = user
                        
                        return
                    }
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
}

