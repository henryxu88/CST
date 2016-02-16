//
//  ProleaveDetailViewController.swift
//  CST
//
//  Created by henry on 16/2/14.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka

class ProleaveDetailViewController: FormViewController {
    
    var proleave: Proleave!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section()
            
            <<< LabelRow(){
                $0.title = "项目名称"
                $0.value = proleave.proInfoName
            }
            
            <<< LabelRow(){
                $0.title = "请假日期"
                $0.value = proleave.leaveDate
            }
            
            <<< LabelRow(){
                $0.title = "请假事由"
                $0.value = proleave.reason
            }
            
            <<< LabelRow(){
                $0.title = "新建人"
                $0.value = proleave.createrName
            }
            
            <<< LabelRow(){
                $0.title = "新建时间"
                $0.value = proleave.createDate
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
