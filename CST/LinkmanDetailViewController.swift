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

        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section("基本信息")
            
            <<< LabelRow(){
                $0.title = "姓名"
                $0.value = linkman.name
            }
            
            <<< LabelRow(){
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
    
    @IBAction func returnBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
