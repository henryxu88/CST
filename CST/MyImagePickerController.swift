//
//  MyImagePickerController.swift
//  CST
//
//  Created by henry on 16/2/29.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import ImagePicker

class MyImagePickerController: ImagePickerController {
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Configuration.cancelButtonTitle = "取消"
        Configuration.doneButtonTitle = "完成"
        Configuration.noImagesTitle = "没有任何图片"
        Configuration.noCameraTitle = "没有摄像头"
        Configuration.settingsTitle = "设置"
    }
    
    
    
}
