//
//  LinkmanDetailViewController.swift
//  CST
//
//  Created by henry on 16/1/29.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Eureka

class LinkmanDetailViewController: FormViewController {
    
    var linkman: Linkman!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()

        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section("基本信息")
            
            <<< LabelRow(){
                $0.title = "姓名"
                $0.value = linkman.name
            }
            
            <<< PushRow<String>(){
                $0.title = "客户信息"
                $0.value = linkman.clientName
            }
            
            <<< LabelRow(){
                $0.title = "常用称呼"
                $0.value = linkman.subName
            }
            
            <<< LabelRow(){
                $0.title = "职位"
                $0.value = linkman.duty
            }
            
            +++ Section("联系方式")
            
            <<< LabelRow(){
                $0.title = "办公电话"
                $0.value = linkman.tel
            }
            
            <<< LabelRow(){
                $0.title = "手机"
                $0.value = linkman.mobile
            }
            
            <<< LabelRow(){
                $0.title = "备用手机"
                $0.value = linkman.mobile_back
            }
            
            <<< LabelRow(){
                $0.title = "邮箱"
                $0.value = linkman.email
            }
            
            +++ Section("其他信息")
            
            <<< LabelRow(){
                $0.title = "生日"
                $0.value = linkman.birthday
            }
            
            <<< LabelRow(){
                $0.title = "个人喜好"
                $0.value = linkman.preferences
            }
            
            +++ Section("备注信息")
            
            <<< TextAreaRow() {
                $0.value = linkman.remark
                $0.disabled = true
            }
            
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Linkman_Client" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ClientDetailViewController
            controller.client = sender as! Client
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Linkman_Client" {
            if sender != nil {
                return true
            }
        }
       
        return false
    }
    
    func setDetailObj(keyId: String) {
        ClientApi.getClientDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    self.performSegueWithIdentifier("Linkman_Client", sender: obj)
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        })
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("section: \(indexPath.section) row: \(indexPath.row)")
        if indexPath.section == 0 && indexPath.row == 1 {
            setDetailObj(linkman.clientId)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 && indexPath.row == 1 {
            return indexPath
        }
        return nil
    }
}


