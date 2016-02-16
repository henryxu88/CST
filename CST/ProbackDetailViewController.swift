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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form +++
            Section("反馈信息")
            
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
            
            <<< ImagesRow("ImagesRow"){
                $0.value = Set(proback.photoList.flatMap{$0})
                $0.cell.delegateShow = self
            }
        
//        let imagesRow : ImagesRow? = form.rowByTag("ImagesRow")
//        imagesRow?.cell.delegateShow = self
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
        
        let index = currentImageView.tag - 1001
        browser.setInitialPageIndex(index)
        
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
