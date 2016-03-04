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

//MARK: ImagesCell
public class ImagesCell : Cell<Set<String>>, CellType {
    
    
    // 图片缓存用
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    weak var delegateShow: ShowImagesProtocol!
    
    var isNewAdd = false        // 是否是新添加的选择照片
    var maxAddNum = 0           // 最多可以上传的照片数
    var baseTag = 1001          // imageView的tag起始数
    var photos = [SSPhoto]()
    var count = 0
    var urls = [String]()       // 已经上传的图片的URL集合
    var images = [UIImage]()    // 通过图片选择控件选中的图片集合
    
    func initData(){
        
        if isNewAdd {
            count = images.count
        } else {
            if let value = row.value {
                count = value.count
                urls = Array(value.flatMap{$0})
            }
        }
        
        height = {
            var h: CGFloat
            var c = 0
            
            if self.isNewAdd {
                c = self.maxAddNum
            } else {
                c = self.count
            }
            
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
//        print("count:\(count)")
        
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
            
            if isNewAdd {
                imageView.image = images[i]
            } else {
                let surl = urls[i]
                let url = NSURL(string: surl)!
                imageView.af_setImageWithURL(url)
            }
            imageView.tag = baseTag + i
            
            let tap = UITapGestureRecognizer(target: self, action: "imageOnScreenTapped:")
            imageView.addGestureRecognizer(tap)
            imageView.userInteractionEnabled = true
            
            self.contentView.addSubview(imageView)
        }
    }
    
    func imageOnScreenTapped(sender: UITapGestureRecognizer) {
        if photos.isEmpty {
            for i in 0..<count {
                let imageView = self.contentView.viewWithTag(baseTag + i) as! UIImageView
                if let image = imageView.image {
                    photos.append(SSPhoto(image: image))
                }
            }
        }
        
        if !photos.isEmpty {
            let imageView = sender.view as! UIImageView
//            print("imageOnScreenTapped:\(imageView.tag)")
            delegateShow.showImages(photos, currentImageView: imageView)
        }
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