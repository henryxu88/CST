//
//  ProbackDetailViewController.swift
//  CST
//
//  Created by henry on 16/2/14.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka
import SSImageBrowser

class ProbackDetailViewController: FormViewController {
    
    var proback: Proback!
    
    //MARK: - 设置按钮
    func setupRightButtons(){
        var items = [UIBarButtonItem]()
        
        let btnComment = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Organize, target: self, action: #selector(ProbackDetailViewController.commentButtonTapped))
        btnComment.tintColor = UIColor.whiteColor()
        items.append(btnComment)
        
        let btnEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: #selector(ProbackDetailViewController.editButtonTapped))
        btnEdit.tintColor = UIColor.whiteColor()
        items.append(btnEdit)
        
        navigationItem.setRightBarButtonItems(items, animated: true)
    }
    
//    override func returnButtonTapped() {
//        navigationController?.popToRootViewControllerAnimated(true)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "项目反馈"
        
        setupReturnButton()
        setupRightButtons()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form
            +++ Section("反馈履历"){
                $0.hidden = Condition.Predicate(NSPredicate(value: proback.hasResume == "0"))
            }
            
            <<< ButtonRow("resumeButtonRow") {
                $0.title = "打开反馈履历列表"
                $0.onCellSelection(self.resumeButtonTapped)
            }
        
            +++ Section("反馈信息")
            
            <<< LabelRow(){
                $0.title = "项目名称"
                $0.value = proback.name
            }
            
            <<< LabelRow(){
                $0.title = "反馈类别"
                $0.value = proback.categoryName
            }
            
            <<< LabelRow(){
                $0.title = "反馈日期"
                $0.value = proback.backDate
            }
            
            <<< LabelRow(){
                $0.title = "反馈地址"
                $0.value = proback.address
            }
            
            <<< LabelRow(){
                $0.title = "是否正常"
                if proback.regular == "1" {
                    $0.value = "正常"
                } else {
                    $0.value = "不正常"
                }
            }
            
            <<< LabelRow(){
                $0.title = "反馈人"
                $0.value = proback.createrName
            }
            
            +++ Section("反馈内容")
            
            <<< TextAreaRow() {
                $0.value = proback.content
                $0.disabled = true
            }
            
            +++ Section("通知人员")
            
            <<< TextAreaRow() {
                
                $0.value = proback.noticeMen.flatMap({ (user: UserEasyView) -> String in
                    return user.name
                }).joinWithSeparator("、")
                $0.disabled = true
            }
        
            +++ Section("备注信息")
            
            <<< TextAreaRow() {
                $0.value = proback.mark
                $0.disabled = true
            }
        
            +++ Section("照片列表")
            
            <<< ShowImagesRow("ShowImagesRow"){
                $0.value = Set(proback.photoList.flatMap{$0})
                $0.cell.delegateShow = self
            }
        
    }
    
    func resumeButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        // 跳转到ResumeListViewController界面
        let vc = storyboard!.instantiateViewControllerWithIdentifier("ResumeListViewController") as? ResumeListViewController
        vc?.keyId = proback.id
        
        let nav = UINavigationController(rootViewController: vc!)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0 && indexPath.row == 0 && proback.hasResume == "1" {
            return indexPath
        }
        return nil
    }
    
    // MARK: - 批注按钮事件
    func commentButtonTapped() {
        // 跳转到CommentDetailViewController界面
        let vc = storyboard!.instantiateViewControllerWithIdentifier("CommentDetailViewController") as? CommentDetailViewController
        vc?.targetId = proback.id
        let nav = UINavigationController(rootViewController: vc!)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    // MARK: - 编辑按钮事件
    func editButtonTapped() {
        // 跳转到ProbackInputViewController界面
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProbackInputViewController") as? ProbackInputViewController
        vc?.proback = self.proback
        let nav = UINavigationController(rootViewController: vc!)
        
        let presentingVC = self.presentingViewController
        self.dismissViewControllerAnimated(true) {
            presentingVC!.presentViewController(nav, animated: true, completion: nil)
        }
    }
}

extension ProbackDetailViewController: SSImageBrowserDelegate, ShowImagesProtocol {
    
    func showImages(images: [SSPhoto], currentImageView: UIImageView) {
        // Create and setup browser
        let browser = SSImageBrowser(aPhotos: images, animatedFromView: currentImageView)
        
        // using initWithPhotos:animatedFromView: method to use the zoom-in animation
        browser.delegate = self
        browser.displayActionButton = true
        browser.displayArrowButton = true
        browser.displayCounterLabel = true
        browser.usePopAnimation = true
        browser.scaleImage = currentImageView.image
        
        let index = currentImageView.tag % 1000
        browser.setInitialPageIndex(index - 1)
        
        // Show
        presentViewController(browser, animated: true, completion: nil)
    }
    
    func photoBrowser(photoBrowser: SSImageBrowser, captionViewForPhotoAtIndex index: Int) -> SSCaptionView! {
        return nil
    }
    
    func photoBrowser(photoBrowser: SSImageBrowser, didDismissActionSheetWithButtonIndex index: Int, photoIndex: Int) {
        
    }
    
    func photoBrowser(photoBrowser: SSImageBrowser, didDismissAtPageIndex index: Int) {
        
    }
    
    func photoBrowser(photoBrowser:SSImageBrowser, didShowPhotoAtIndex index:Int) {
        
    }
    
    func photoBrowser(photoBrowser:SSImageBrowser, willDismissAtPageIndex index:Int) {
        
    }
}
