//
//  ProinfoDetailViewController.swift
//  CST
//
//  Created by henry on 16/2/3.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Eureka

class ProinfoDetailViewController: FormViewController {
    
    var proinfo: Proinfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        setupCommentButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form
            +++ Section()
            
            <<< LabelRow(){
                $0.title = "项目名称"
                $0.value = proinfo.name
            }
            
            <<< LabelRow(){
                $0.title = "项目类别"
                $0.value = proinfo.categoryName
            }
            
            <<< PushRow<String>(){
                $0.title = "客户信息"
                $0.value = proinfo.clientName
            }
            
            <<< LabelRow(){
                $0.title = "所在区域"
                $0.value = proinfo.province + proinfo.city + proinfo.county
            }
            
            <<< LabelRow(){
                $0.title = "项目地址"
                $0.value = proinfo.address
            }
            
            +++ Section("人员信息")
            
            <<< LabelRow(){
                $0.title = "联系人"
                $0.value = proinfo.linkmanName
            }
            
            <<< LabelRow(){
                $0.title = "项目总监"
                $0.value = proinfo.chief
            }
            
            <<< TextAreaRow() {
                $0.value = "项目组成员：\(proinfo.group)"
                $0.disabled = true
            }
            
            
            +++ Section("其他信息")
            
            <<< LabelRow(){
                $0.title = "启动时间"
                $0.value = proinfo.start
            }
            
            <<< LabelRow(){
                $0.title = "完成时间"
                $0.value = proinfo.end
            }
        
            <<< LabelRow(){
                $0.title = "新建人"
                $0.value = proinfo.createrName
            }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Proinfo_Client" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ClientDetailViewController
            controller.client = sender as! Client
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Proinfo_Client" {
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
                    self.performSegueWithIdentifier("Proinfo_Client", sender: obj)
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            setDetailObj(proinfo.clientId)
        }
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 && indexPath.row == 2 {
            return indexPath
        }
        return nil
    }
    
    // MARK: - 批注按钮事件
    func commentButtonTapped() {
        // 跳转到CommentDetailViewController界面
        let vc = storyboard!.instantiateViewControllerWithIdentifier("CommentDetailViewController") as? CommentDetailViewController
        vc?.targetId = proinfo.id
        vc?.targetClass = Words.targetClass_proinfo
        let nav = UINavigationController(rootViewController: vc!)
        self.presentViewController(nav, animated: true, completion: nil)
    }

}
