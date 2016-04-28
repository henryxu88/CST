//
//  MenuSectionHeaderView.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit

class MenuSectionHeaderView: UIView {
    var title = ""
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.backgroundColor = UIColor(red: 110.0/255.0, green: 113.0/255.0, blue: 115.0/255.0, alpha: 1.0)
        self.backgroundColor = Style.mainMenuViewBackgroundColor
        
        label = UILabel(frame: CGRectMake(15, CGRectGetMaxY(self.bounds)-35,CGRectGetWidth(self.bounds)-30, 30))
        label.font = UIFont.boldSystemFontOfSize(16.0)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.darkGrayColor()
        label.autoresizingMask = [UIViewAutoresizing.FlexibleWidth , UIViewAutoresizing.FlexibleTopMargin]
        self.addSubview(label)
        self.clipsToBounds = false
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setSectionTitle(title: String){
        self.title = title
        label.text = title.uppercaseString
    }
    
    // Only override drawRect: if you perform custom drawing.
//    override func drawRect(rect: CGRect) {
//        // 在section的底部画根线
//        let context = UIGraphicsGetCurrentContext()
//        let lineColor = UIColor(red: 94.0/255.0, green: 97.0/255.0, blue: 99.0/255.0, alpha: 1.0)
//        
//        CGContextSetStrokeColorWithColor(context, lineColor.CGColor)
//        CGContextSetLineWidth(context, 1.0)
//        
//        CGContextMoveToPoint(context, CGRectGetMinX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
//        CGContextAddLineToPoint(context, CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds) - 0.5)
//        
//        CGContextStrokePath(context)
//    }
    

}
