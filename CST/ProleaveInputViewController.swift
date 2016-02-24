//
//  ProleaveInputViewController.swift
//  CST
//
//  Created by henry on 16/2/24.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka

class ProleaveInputViewController: FormViewController {
    
    var proinfo: Proinfo!
    var proleave: Proleave?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section()
            
            <<< LabelRow(){
                $0.title = "项目名称"
                
            }
            
            <<< LabelRow(){
                $0.title = "请假日期"
//                $0.value = proleave.leaveDate
            }
            
            <<< LabelRow(){
                $0.title = "请假事由"
//                $0.value = proleave.reason
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
