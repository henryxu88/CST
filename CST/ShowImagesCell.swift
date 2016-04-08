//
//  ShowImagesCell.swift
//  CST
//
//  Created by henry on 16/3/8.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Eureka
import AlamofireImage
import SSImageBrowser

//MARK: ShowImagesCell
public class ShowImagesCell : Cell<Set<String>>, CellType {
    
    weak var delegateShow: ShowImagesProtocol!
    
    var photos = [SSPhoto]()
    var count = 0
    var urls = [String]()       // 已经上传的图片的URL集合
    
    func initData(){
        
        if let value = row.value {
            count = value.count
            urls = Array(value.flatMap{$0})
        }
        
        height = {
            var h: CGFloat
            let c = self.count
            
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

        photos = [SSPhoto]()
        
        row.title = nil
        super.setup()
        selectionStyle = .None
        
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
            imageView.tag = 1001 + i
            let surl = urls[i]
            let url = NSURL(string: surl)!
            imageView.af_setImageWithURL(url)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(ShowImagesCell.imageOnScreenTapped(_:)))
            imageView.addGestureRecognizer(tap)
            imageView.userInteractionEnabled = true
            
            self.contentView.addSubview(imageView)

        }
    }
    
    func imageOnScreenTapped(sender: UITapGestureRecognizer) {
        if photos.isEmpty {
            for i in 0..<count {
                let imageView = self.contentView.viewWithTag(1001 + i) as? UIImageView
                if let image = imageView!.image {
                    photos.append(SSPhoto(image: image))
                }
            }
        }
        
        let imageView = sender.view as! UIImageView
        delegateShow.showImages(photos, currentImageView: imageView)
    }
    
}

//MARK: ShowImagesRow
public final class ShowImagesRow: Row<Set<String>, ShowImagesCell>, RowType {
    
    required public init(tag: String?) {
        super.init(tag: tag)
        displayValueFor = nil
        cellProvider = CellProvider<ShowImagesCell>(nibName: "ShowImagesCell")
    }
}