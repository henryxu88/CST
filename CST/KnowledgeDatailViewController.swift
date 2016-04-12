//
//  KnowledgeDatailViewController.swift
//  CST
//
//  Created by henry on 16/2/23.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka
import MBProgressHUD

class KnowledgeDetailViewController: FormViewController {
    
    var knowledge: Knowledge!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section("基本信息")
            
            <<< LabelRow(){
                $0.title = "知识大类"
                $0.value = knowledge.superType
            }
            
            <<< LabelRow(){
                $0.title = "知识小类"
                $0.value = knowledge.subType
            }
            
            <<< LabelRow(){
                $0.title = "知识标题"
                $0.value = knowledge.name
            }
            
            
            +++ Section("图文说明"){
                $0.hidden = Condition.Predicate(NSPredicate(value: knowledge.contextHtml.isEmpty))
            }
            
            <<< ButtonRow("contextButtonRow") {
                $0.title = "显示图文内容"
                $0.onCellSelection(self.contextButtonTapped)
            }
            
            +++ Section("在线预览"){
                $0.hidden = Condition.Predicate(NSPredicate(value: knowledge.knowledgeId.isEmpty))
            }
            
            <<< ButtonRow("inlineButtonRow") {
                $0.title = "打开预览文件"
                $0.onCellSelection(self.inlineButtonTapped)
            }
        
        
    }
    
    func gotoWebView(strTitle: String,strUrl: String){
        // 跳转到WebViewController界面
        let vc = storyboard!.instantiateViewControllerWithIdentifier("WebViewController") as? WebViewController
        vc?.strTitle = strTitle
        vc?.strUrl = strUrl
        let nav = UINavigationController(rootViewController: vc!)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func contextButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {

        gotoWebView(knowledge.name, strUrl: NetManager.KNOWLEDGE_WEBVIEW + knowledge.id)
        
    }
    
    func inlineButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "提示"
        hud.detailsLabelText = "正在进行操作，请等待......"
        hud.userInteractionEnabled = false
        KnowledgeApi.getFileViewUrl(knowledge.id) { (result, url) -> Void in
            hud.hide(true)
            
            if result {
                
                if url == nil {
                    self.displayMessage("获取文件URL出错！")
                } else {
//                    print("url:\(url!)")
                    self.gotoWebView(self.knowledge.name, strUrl: url!)
                }
                
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
}
