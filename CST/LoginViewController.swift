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
        navigationController?.navigationBarHidden = true
        // 先判断是否已经登录过,如果已经登录过，则跳过介绍页面
        if NSUserDefaults.standardUserDefaults().stringForKey("hasLogged") != "yes" {
            let ghView = GHWalkThroughView(frame: view.bounds)
            ghView.dataSource = self
            
            ghView.floatingHeaderView = nil
            ghView.walkThroughDirection = .Horizontal
//            ghView.closeTitle = "跳过"
            
            ghView.showInView(view, animateDuration: 0.3)
        } else {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let username = userDefaults.stringForKey("username")
            let digest = userDefaults.stringForKey("digest")
            
            if let username=username, digest=digest {
                autoLogin(username,digest:digest)
            }
        }
        
    }
    
    func autoLogin(username: String,digest: String){
        UserApi.authc(username, digest: digest, resultClosure: { (result, user) in
            if result {
                if let user = user {
                    let res = user.result
                    
                    if res.OK() {
                        //登录成功
                        user.username = username
                        user.digest = digest
                        self.appDelegate.saveLoginInfo(user)
                        
                        //跳转到主界面
                        self.appDelegate.buildUserInterface()
                    } else {
                        //登录失败
                        let msg = res.errorMessage
                        self.view.makeToast("自动登录失败：\(msg)", duration: 3.0, position: .Center)
                    }
                }
                
            } else {
                self.view.makeToast("对不起，现在无法自动登录！", duration: 3.0, position: .Center)
            }
        })
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLoginSuccess() {
        view.endEditing(true)
        
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
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let userDeviceId = userDefaults.stringForKey("userDeviceId")
        var deviceId = ""
        if let userDeviceId=userDeviceId {
            deviceId = userDeviceId
        } else {
            guard let deviceId = UIDevice.currentDevice().identifierForVendor?.UUIDString else {
                displayMessage("无法获取设备的唯一码！")
                return
            }
            userDefaults.setObject(deviceId, forKey: "userDeviceId")
        }
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "提示"
        hud.detailsLabelText = "正在登录，请等待......"
        hud.userInteractionEnabled = false
        
        UserApi.loginWithDeviceId(userName, password: userPwd, deviceId: deviceId) { (result, user) in
            hud.hide(true)
            if result {
                if let user = user {
                    let res = user.result
                    
                    if res.OK() {
                        //登录成功
                        user.username = userName
                        //根据"uid":aid , "u":username , 生成HMAC（Hash-based Message Authentication Code）：基于散列的消息认证码
                        user.digest = CrypoUtils.digestWith(user.salt, AndContent: user.aid + user.username)
                        
                        self.appDelegate.saveLoginInfo(user)
                        
                        // 记录下必要信息
                        let userDefaults = NSUserDefaults.standardUserDefaults()
                        userDefaults.setObject(user.username, forKey: "username")
                        userDefaults.setObject(user.digest, forKey: "digest")
                        userDefaults.setObject("yes", forKey: "hasLogged")
                        userDefaults.synchronize()
                        
                        //提示登录成功并构建主界面
                        self.handleLoginSuccess()
                    } else {
                        //登录失败
                        self.appDelegate.cleanLoginInfo()
                        let msg = res.errorMessage
                        self.view.makeToast("登录失败：\(msg)", duration: 3.0, position: .Center)
                    }
                }
                
            } else {
                self.view.makeToast("对不起，现在无法登录！", duration: 3.0, position: .Center)
            }
        }
        
    }
}

// MARK: - GHWalkThroughViewDataSource
extension LoginViewController: GHWalkThroughViewDataSource {

    func numberOfPages() -> Int {
        return 3
    }
    
    func configurePage(cell: GHWalkThroughPageCell!, atIndex index: Int) {
        cell.titleImage = nil
        cell.title = ""
        cell.desc = ""
    }
    
    func bgImageforPage(index: Int) -> UIImage! {
        return UIImage(named: "welcome0\(index + 1).jpg")
    }
}

