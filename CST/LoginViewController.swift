//
//  ViewController.swift
//  CST
//
//  Created by henry on 16/1/15.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import SwiftyJSON

class LoginViewController: UIViewController {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

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
    
    func handleLoginSuccess() {
        view.endEditing(true)
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "login")
        view.makeToast("登录成功", duration: 2.0, position: ToastPosition.Center)
        // 生成主界面
        appDelegate.buildUserInterface()
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
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "提示"
        hud.detailsLabelText = "正在登录，请等待......"
        hud.userInteractionEnabled = false
        
        let url = NetManager.URL_LOGIN
        let parameters = ["username": userName, "password": userPwd, "deviceId": deviceId]
        Alamofire.request(.POST, url ,parameters: parameters).validate().responseJSON { response in
            hud.hide(true)
            
            switch response.result {
            case .Success:
                
                if let value = response.result.value {
                    
                    let user = User.parse(value)
                    let res = user.result
                    
                    if res.OK() {
                        //登录成功
                        user.username = userName
                        //根据"uid":aid , "u":username , 生成HMAC（Hash-based Message Authentication Code）：基于散列的消息认证码
                        user.digest = CrypoUtils.digestWith(user.salt, AndContent: user.aid + user.username)
                        
                        self.appDelegate.saveLoginInfo(user)
                        
                        //记录是否曾经登录
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject("yes", forKey: "hasLogged")
                        userDefaults.synchronize()
                        
                        //提示登录成功并构建主界面
                        self.handleLoginSuccess()
                    } else {
                        //登录失败
                        self.appDelegate.cleanLoginInfo()
//                        let code = res.errorCode
                        let msg = res.errorMessage
//                        let info = "错误代码 － \(code) 错误信息 － \(msg)"
                        self.view.makeToast("登录失败：\(msg)", duration: 3.0, position: .Center)
                    }
                }
                
            case .Failure(let error):
                print(error)
                self.view.makeToast("对不起，现在无法登录！", duration: 3.0, position: .Center)
            }
        }
        
    }
}

