//
//  ImagesCell.swift
//  CST
//
//  Created by henry on 16/2/15.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import Eureka
import AlamofireImage
import SSImageBrowser

protocol ShowImagesProtocol: NSObjectProtocol {
    func showImages(images: [SSPhoto], currentImageView: UIImageView)
}

//MARK: ImagesCell : 新添加的选择照片
public class ImagesCell : Cell<Set<String>>, CellType {
    
    weak var delegateShow: ShowImagesProtocol!
    
    var maxAddNum = 0           // 最多可以上传的照片数
    var photos = [SSPhoto]()
    var count = 0
    var images: [UIImage]?    // 通过图片选择控件选中的图片集合
    
    func initData(){
        
        count = images!.count
        
        height = {
            var h: CGFloat
            let c = self.maxAddNum
            
            switch c {
            case 0:
                h = 0
            case 1..<4:
                h = 110
            case 4..<7:
                h = 210
            default:
                h = 310
            }
            return h
        }
        
    }
    
    public override func setup() {
        images = [UIImage]()
        photos = [SSPhoto]()
        
        row.title = nil
        super.setup()
        selectionStyle = .None
        
        initData()
        reloadData()
    }
    
    public override func update() {
        initData()
        reloadData()
    }
    
    func reloadData(){
        if count == 0 {
            return
        }

        if contentView.subviews.count>0 {
            for subview in contentView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        let itemWidth = CGFloat(90.0)
        let itemHeight = CGFloat(90.0)
        let itemMargin = CGFloat(10.0)
        let itemCols = 3
        
        for i in 0..<count {
            
            let c = i % itemCols
            let r = i / itemCols
            
            let x = itemMargin + (itemWidth + itemMargin) * CGFloat(c)
            let y = itemMargin + (itemWidth + itemMargin) * CGFloat(r)
            
            let imageView = UIImageView(frame: CGRectMake(x, y, itemWidth, itemHeight))
            imageView.contentMode = .ScaleAspectFit
            imageView.tag = 2001 + i
            
            imageView.image = images![i]
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ImagesCell.imageOnScreenTapped(_:)))
            imageView.addGestureRecognizer(tap)
            imageView.userInteractionEnabled = true
            
            self.contentView.addSubview(imageView)
        }
    }
    
    func imageOnScreenTapped(sender: UITapGestureRecognizer) {
        if !photos.isEmpty {
            photos.removeAll()
        }
        
        for i in 0..<count {
            photos.append(SSPhoto(image: images![i]))
        }
        
        let imageView = sender.view as! UIImageView
        delegateShow.showImages(photos, currentImageView: imageView)
    }
    
}

//MARK: ImagesRow
public final class ImagesRow: Row<Set<String>, ImagesCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<ImagesCell>(nibName: "ImagesCell")
    }
}