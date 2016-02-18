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
    
    var urls = [String]()
    var photos = [SSPhoto]()
    var count = 0
    
    func initData(){
        
        photos = [SSPhoto]()
        if let value = row.value {
            count = value.count
            urls = Array(value.flatMap{$0})
        }
        
        height = {
            var h: CGFloat
            switch self.count {
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
        initData()

        row.title = nil
        super.setup()
        selectionStyle = .None
        
        reloadData()
        
    }
    
    func reloadData(){
        let itemWidth = CGFloat(90.0)
        let itemHeight = CGFloat(90.0)
        let itemMargin = CGFloat(10.0)
        let itemCols = 3
        
        for i in 0..<count {
            if urls[i].isEmpty {
                continue
            }

            let c = i % itemCols
            let r = i / itemCols
            
            let x = itemMargin + (itemWidth + itemMargin) * CGFloat(c)
            let y = itemMargin + (itemWidth + itemMargin) * CGFloat(r)
            
            let imageView = UIImageView(frame: CGRectMake(x, y, itemWidth, itemHeight))
            imageView.tag = 1001 + i
            imageView.contentMode = .ScaleAspectFit
            
            let url = NSURL(string: urls[i])!
            imageView.af_setImageWithURL(url)
            
            let tap = UITapGestureRecognizer(target: self, action: "imageOnScreenTapped:")
            imageView.addGestureRecognizer(tap)
            imageView.userInteractionEnabled = true
            
            self.contentView.addSubview(imageView)
        }
    }
    
    func imageOnScreenTapped(sender: UITapGestureRecognizer) {
//        print("imageOnScreenTapped")
        if photos.isEmpty {
            for i in 0..<count {
                let imageView = self.contentView.viewWithTag(1001 + i) as! UIImageView
                if let image = imageView.image {
                    photos.append(SSPhoto(image: image))
                }
            }
        }
        
        if !photos.isEmpty {
            let imageView = sender.view as! UIImageView
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