//
//  ProsigninDetailViewController.swift
//  CST
//
//  Created by henry on 16/2/5.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka

class ProsigninDetailViewController: FormViewController {
    
    var prosignin: Prosignin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section("项目信息")
            
            <<< LabelRow(){
                $0.title = "项目名称"
                $0.value = prosignin.proInfoName
            }
            
            <<< LabelRow(){
                $0.title = "所在区域"
                $0.value = prosignin.proInfoArea
            }
            
            <<< LabelRow(){
                $0.title = "项目地址"
                $0.value = prosignin.proInfoAddress
            }
            
            +++ Section("签到信息")
            
            <<< LabelRow(){
                $0.title = "签到时间"
                $0.value = prosignin.createDate
            }
            
            <<< LabelRow(){
                $0.title = "签到人"
                $0.value = prosignin.createrName
            }
            
            <<< LabelRow(){
                $0.title = "签到地址"
                $0.value = prosignin.address
            }
        
            <<< LabelRow(){
                $0.title = "考勤状态"
                $0.value = prosignin.status
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
