//
//  FastButtonsView.swift
//  CST
//
//  Created by henry on 16/4/13.
//  Copyright © 2016年 9joint. All rights reserved.
// @IBDesignable

import UIKit
import MMDrawerController

class FastButtonsView : UIView {

    var view:UIView!;
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var feedbackButton: UIButton!
    
    @IBOutlet weak var leaveButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib ()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib ()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "FastButtonsView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        self.addSubview(view);
    }
    
    
    @IBAction func signButtonTapped(sender: UIButton) {
        doHandle("sign")
    }
    
    
    @IBAction func feedbackButtonTapped(sender: UIButton) {
        doHandle("feedback")
    }
    
    @IBAction func leaveButtonTapped(sender: UIButton) {
        doHandle("leave")
    }
    
    func doHandle(handleType: String) {
//        print("handleType:\(handleType)")
        if let drawer = appDelegate.drawerContainer {
            appDelegate.handleType = handleType
            if drawer.openSide == .Left {
                drawer.toggleDrawerSide(.Left, animated: true, completion: nil)
            }
            drawer.openDrawerSide(.Right, animated: true, completion: nil)
        }
    }
    
}
