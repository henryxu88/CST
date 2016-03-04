//
//  ProleaveInputViewController.swift
//  CST
//
//  Created by henry on 16/2/24.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MBProgressHUD
import Eureka

class ProleaveInputViewController: FormViewController {
    
    let timestamp = String(NSDate.timeIntervalSinceReferenceDate())
    var proleave: Proleave!
    
    // 保存按钮触发的操作
    func submit() {
        
        if proleave.leaveDate.isEmpty {
            view.makeToast("请选择请假日期！")
            return
        }
        
        let reason = form.rowByTag("reasonRow")?.baseValue as? String
        if let reason = reason where !reason.isEmpty {
            proleave.reason = reason
        }
        if proleave.reason.isEmpty {
            view.makeToast("请填写请假原因！")
            return
        }

        proleave.timestamp = timestamp
        
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "提示"
        hud.detailsLabelText = "正在进行操作，请等待......"
        hud.userInteractionEnabled = false
        
        ProleaveApi.createProleave(proleave) { (result) -> Void in
            hud.hide(true)
            if result {
                self.view.makeToast(NetManager.requestSuccess)
                
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        setupSaveButton()
        
        // set init value
        proleave.leaveDate = NSDate().fs_stringWithFormat("yyyy-MM-dd")
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form
            +++ Section()
            
            <<< LabelRow(){
                $0.title = "项目名称"
                $0.value = proleave.proInfoName
            }
            
            <<< DateRow("leaveDateRow"){
                $0.title = "请假日期"
                $0.value = NSDate()
                let formatter = NSDateFormatter()
                formatter.locale = .currentLocale()
                formatter.dateStyle = .LongStyle
                $0.dateFormatter = formatter
            }.onChange({ [weak self] row in
                let leaveDate = row.value
                if let leaveDate = leaveDate {
                    let strLeaveDate = leaveDate.fs_stringWithFormat("yyyy-MM-dd")
                    self!.proleave.leaveDate = strLeaveDate
                }
            })
            
            +++ Section("请假事由")
            
            <<< TextAreaRow("reasonRow") {
                $0.placeholder = "必填"
            }
            
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
