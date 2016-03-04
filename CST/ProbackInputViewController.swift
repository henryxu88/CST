//
//  ProbackInputViewController.swift
//  CST
//
//  Created by henry on 16/2/26.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import Eureka
import SSImageBrowser
import ImagePicker
import MBProgressHUD

class ProbackInputViewController: FormViewController {
    
    let timestamp = String(NSDate.timeIntervalSinceReferenceDate())
    var proback: Proback!
    var dicts = [DictEntry]()
    
    var photoList = [String]()
    
    var newImages = [UIImage]()
    var hasUploaded = 0
    var isNewDoc = true
    
    let imagePickerController = MyImagePickerController()
    
    // 提交时数据校验
    func doSubmit() {
        if proback.projectId.isEmpty {
            displayMessage("该反馈所对应的项目不能为空！")
            return
        }
        
        let categoryName = form.rowByTag("categoryRow")?.baseValue as! String
        if categoryName.isEmpty {
            displayMessage("该反馈的反馈类别不能为空！")
            return
        } else {
            for dict in dicts {
                if dict.name == categoryName {
                    proback.categoryName = categoryName
                    proback.categoryId = dict.id
                }
            }
        }
        
        if proback.backDate.isEmpty {
            displayMessage("该反馈的反馈日期不能为空！")
            return
        }
        
        let regular = form.rowByTag("regularRow")?.baseValue as! String
        if regular == "正常" {
            proback.regular = "1"
        } else {
            proback.regular = "0"
        }
        
        proback.noticemanIds = proback.noticeMen.flatMap({$0.id}).joinWithSeparator(";")
        
        proback.timestamp = timestamp
        
        // 开始提交
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "提示"
        hud.detailsLabelText = "正在进行操作，请等待......"
        hud.userInteractionEnabled = false
        
        ProbackApi.createProback(proback) { (isOk,result) -> Void in
            hud.hide(true)
            if isOk {
                
                if self.newImages.count > 0 {
                    self.uploadImages(result!.errorMessage) // 上传图片
                } else {
                    self.handleSuccess()
                }
                
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    // 保存按钮触发的操作
    func submit() {

        let alertController = UIAlertController(title: "提示", message: "确定提交吗？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {(action) -> () in
            self.doSubmit()
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler:nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func handleSuccess() {
        view.makeToast("反馈信息提交成功！")
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        if isNewDoc {
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        } else {
            // 跳转到ProbackListViewController界面
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        }
    }
    
    func uploadImages(keyId: String) {
        uploadImage(keyId, image: newImages[0])
    }
    
    func uploadImage(keyId: String, image: UIImage) {
        ProbackApi.uploadProbackPhoto(keyId, image: image, resultClosure: { (isOk, result) -> Void in
            if isOk {
                let c = ++self.hasUploaded
                if c == self.newImages.count {
                    self.handleSuccess()
                } else {
                    self.uploadImage(keyId, image: self.newImages[c])
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        })
    }

    
    func getDictEntries(){
        OtherApi.getDictList("ProBackCategory", resultClosure: { (isOk, objs) -> Void in
            if isOk {
                if let objs = objs {
                    self.dicts = objs

                    let row: ActionSheetRow<String>? = self.form.rowByTag("categoryRow")
                    row?.options = objs.flatMap{ $0.name }
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        })
    }
    
    override func returnButtonTapped() {
        
        let alertController = UIAlertController(title: "确定离开吗？", message: "未保存的数据会丢失！", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {(action) -> () in
            if self.isNewDoc {
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.navigationController?.popToRootViewControllerAnimated(true)
            }
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler:nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 9
        
        // set init value
        if proback.id.isEmpty {
            proback.backDate = NSDate().fs_stringWithFormat("yyyy-MM-dd")
        } else {
            if !proback.photoList.isEmpty {
                photoList = proback.photoList
                imagePickerController.imageLimit -= photoList.count
            }
            isNewDoc = false
        }
        
        // buttons
        setupReturnButton()
        setupSaveButton()
        
        // table
        tableView?.rowHeight = 44.0
        
        // Do any additional setup after loading the view.
        form
            +++ Section("反馈信息")
            
            <<< LabelRow(){
                $0.title = "项目名称"
                $0.value = proback.name
            }
            
            <<< ActionSheetRow<String>("categoryRow") {
                $0.title = "反馈类别"
                $0.selectorTitle = "请选择反馈类别："
                $0.value = proback.categoryName
            }
            
            <<< DateRow("backDateRow"){
                    $0.title = "反馈日期"
                    let formatter = NSDateFormatter()
                    formatter.locale = .currentLocale()
                    formatter.dateStyle = .LongStyle
                    formatter.dateFormat = "yyyy-MM-dd"
                    $0.dateFormatter = formatter
                    $0.value = formatter.dateFromString(proback.backDate)
                }.onChange({ [weak self] row in
                    let backDate = row.value
                    if let backDate = backDate {
                        let strBackDate = backDate.fs_stringWithFormat("yyyy-MM-dd")
                        self!.proback.backDate = strBackDate
                    }
                })
            
            <<< SegmentedRow<String>("regularRow"){
                $0.title = "是否正常"
                $0.options = ["正常", "不正常"]
                if proback.regular == "1" {
                    $0.value = "正常"
                } else {
                    $0.value = "不正常"
                }
            }
           
            
            +++ Section("反馈内容")
            
            <<< TextAreaRow() {
                $0.value = proback.content
                }.onChange({ [weak self] row in
                    self!.proback.content = row.value ?? ""
                })
            
            +++ Section("通知人员")
            
            <<< ButtonRow("noticeMenButtonRow") {
                $0.title = "选择通知人员"
                $0.onCellSelection(self.noticeMenButtonTapped)
            }
            
            <<< TextAreaRow("noticeMenRow") {
                $0.value = proback.noticeMen.flatMap({ (user: UserEasyView) -> String in
                    return user.name
                }).joinWithSeparator("、")
                $0.disabled = true
            }
            
            +++ Section("备注信息")
            
            <<< TextAreaRow() {
                $0.value = proback.mark
                }.onChange({ [weak self] row in
                    self!.proback.mark = row.value ?? ""
                })
            
            +++ Section("已上传的照片列表"){
                $0.hidden = Condition.Predicate(NSPredicate(value: proback.photoList.isEmpty))
            }
            
            <<< ImagesRow("uploadedImagesRow"){
                $0.value = Set(proback.photoList.flatMap{$0})
                $0.cell.delegateShow = self
                $0.cell.baseTag = 1001
            }
            
            +++ Section("新添加的照片列表")
            
            <<< ButtonRow("imagesButtonRow") {
                $0.title = "添加图片［最多\(imagePickerController.imageLimit)张］"
                $0.onCellSelection(self.imagesButtonTapped)
            }
            
            <<< ImagesRow("ImagesRow"){
                $0.cell.delegateShow = self
                $0.cell.isNewAdd = true
                $0.cell.baseTag = 2001
                $0.cell.maxAddNum = imagePickerController.imageLimit
            }
    }
    
    
    func noticeMenButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {
        
        // 跳转到UserPickerViewController界面
        let vc = storyboard!.instantiateViewControllerWithIdentifier("UserPickerViewController") as? UserPickerViewController
        vc?.delegate = self
        if !proback.id.isEmpty {
            vc?.lastSelectedUsers = proback.noticeMen
        }
        
        let nav = UINavigationController(rootViewController: vc!)
        self.presentViewController(nav, animated: true, completion: nil)
        
    }
    
    func imagesButtonTapped(cell: ButtonCellOf<String>, row: ButtonRow) {

        presentViewController(imagePickerController, animated: true, completion: nil)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getDictEntries()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

extension ProbackInputViewController: SSImageBrowserDelegate, ShowImagesProtocol {
    
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

// MARK: - 选择人员控制器的代理
extension ProbackInputViewController: UserPickerProtocol {
    func getSelectedUsers(users: [UserEasyView]) {
        if !users.isEmpty {
            if proback.id.isEmpty {
                proback.noticeMen = users
            } else {
                for user in users {
                    proback.noticeMen.append(user)
                }
            }

            let row: TextAreaRow? = self.form.rowByTag("noticeMenRow")
            row?.value = proback.noticeMen.flatMap({$0.name}).joinWithSeparator("、")
            row?.updateCell()
        }
    }
}

// MARK: - 选择图片控制器的代理
extension ProbackInputViewController: ImagePickerDelegate {
    func wrapperDidPress(images: [UIImage]) {
        
    }
    
    func doneButtonDidPress(images: [UIImage]) {
        // 保存图片到应用程序的目录
        newImages = images
        
        dismissViewControllerAnimated(true, completion: nil)
        
        let row: ImagesRow? = self.form.rowByTag("ImagesRow")
        row?.cell.images = images
        row?.cell.update()
    }
    
    func cancelButtonDidPress() {
        
    }
}

