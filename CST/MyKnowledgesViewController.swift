//
//  MyKnowledgesViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController

class MyKnowledgesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLeftButton()
        
        view.backgroundColor = UIColor.orangeColor()
    }
    
//    func setupLeftButton(){
//        let btn = MMDrawerBarButtonItem.init(target: self, action: "hideMenuButtonTapped")
//        btn.tintColor = UIColor.whiteColor()
//        navigationItem.setLeftBarButtonItem(btn, animated: true)
//    }
//    
//    func hideMenuButtonTapped() {
//        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//        appDelegate.drawerContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

}
