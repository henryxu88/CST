//
//  ClientDetailViewController.swift
//  CST
//
//  Created by henry on 16/1/29.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Eureka

class ClientDetailViewController: FormViewController {
    
    var client: Client!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.rowHeight = 44.0

        // Do any additional setup after loading the view.
        form +++
            Section("基本信息")
            
                <<< LabelRow(){
                    $0.title = "客户名称"
                    $0.value = client.name
                }
            
                <<< LabelRow(){
                    $0.title = "客户简称"
                    $0.value = client.subName
                }
            
                <<< LabelRow(){
                    $0.title = "发票抬头"
                    $0.value = client.invoiceTitle
                }
            
                <<< LabelRow(){
                    $0.title = "客户性质"
                    $0.value = client.typeName
                }
            
                <<< LabelRow(){
                    $0.title = "所在区域"
                    $0.value = "\(client.province) \(client.city) \(client.county)"
                }
            
            +++ Section("备注信息")
            
                <<< TextAreaRow() {
                    $0.value = client.remark
                    $0.disabled = true
                }
        
            +++ Section("情况说明")
            
                <<< TextAreaRow() {
                    $0.value = client.situtation
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
