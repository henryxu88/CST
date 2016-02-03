//
//  AnnounceDetailViewController.swift
//  CST
//
//  Created by henry on 16/2/1.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka

class AnnounceDetailViewController: FormViewController {
    
    var announce: Announce!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section("基本信息")
            
            <<< LabelRow(){
                $0.title = "公告主题"
                $0.value = announce.name
            }
            
            <<< LabelRow(){
                $0.title = "发布日期"
                $0.value = announce.publishTime
            }
            
            
            +++ Section("公告内容")
            
            <<< TextAreaRow() {
                $0.value = announce.content
                $0.disabled = true
            }
            
            
            +++ Section("通知成员")
            
            <<< TextAreaRow() {
                $0.value = announce.usersSet
                $0.disabled = true
            }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - UITableViewDelegate
   
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        return nil
    }
}
