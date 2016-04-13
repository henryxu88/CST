//
//  HomePageViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit

class HomePageViewController: UITabBarController {

    var itemArray = [UITabBarItem]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for childView in self.tabBar.subviews {
            if !childView.isKindOfClass(XZMTabbarExtension) {
                childView.removeFromSuperview()
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if itemArray.count>0 {
            itemArray.removeAll()
        }

        /** 添加子控制器 */
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewControllerWithIdentifier("MyMessagesViewController") as? MyMessagesViewController
        tabBarChildViewController(vc1!, norImage: UIImage(named: "tab_bar_message_nor")!, selImage: UIImage(named: "tab_bar_message")! , title: Words.myMessages)
        
        let vc2 = storyboard.instantiateViewControllerWithIdentifier("MyBusinessViewController") as? MyBusinessViewController
        tabBarChildViewController(vc2!, norImage: UIImage(named: "tab_bar_project_nor")!, selImage: UIImage(named: "tab_bar_project")! , title: Words.currentProjects)
        
        let vc3 = storyboard.instantiateViewControllerWithIdentifier("MyKnowledgesViewController") as? MyKnowledgesViewController
        tabBarChildViewController(vc3!, norImage: UIImage(named: "tab_bar_knowledge_nor")!, selImage: UIImage(named: "tab_bar_knowledge")! , title: Words.knowledgeShare)
        
        setTabBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     设置tab bar item对应的控件
     
     - parameter vc:       UIViewController
     - parameter norImage: tab bar item 正常状态下的图片
     - parameter selImage: tab bar item 选中状态下的图片
     - parameter title:    tab bar item 的文字
     */
    func tabBarChildViewController(vc: UIViewController, norImage: UIImage, selImage: UIImage, title: String){
        /** 创建导航控制器 */
        let nav = UINavigationController.init(rootViewController: vc)
        vc.title = title
        /** 创建模型 */
        let tabBarItem = nav.tabBarItem
        tabBarItem.image = norImage
        tabBarItem.selectedImage = selImage
        
        /** 添加到模型数组 */
        if itemArray.isEmpty {
            tabBarItem
        }
        itemArray.append(tabBarItem)
        self.addChildViewController(nav)
    }
    
    /**
     设置tab bar
     */
    func setTabBar(){
        if self.tabBar.subviews.count>0 {
            for subview in self.tabBar.subviews {
                subview.removeFromSuperview()
            }
        }
        /** 创建自定义tabbar */
        let customTabBar = XZMTabbarExtension()
        customTabBar.backgroundColor = Style.barTintTextColor
        customTabBar.frame = tabBar.bounds
        /** 传递模型数组 */
        customTabBar.items = itemArray
        customTabBar.xzm_setShadeItemBackgroundColor(Style.tintColorHalfAlpha)
        
        /** 设置代理 */
        customTabBar.delegate = self
        
        self.tabBar.addSubview(customTabBar)
        
        // 默认显示第一个tab bar item选中
        if let tabBar = self.tabBar.subviews[0] as? XZMTabbarExtension {
            if let btn = tabBar.seletBtn {
                let myImageView = btn.subviews[0] as! UIImageView
                myImageView.highlighted = true
            }
        }
    }
    
}

// MARK: - XZMTabbarExtensionDelegate
extension HomePageViewController: XZMTabbarExtensionDelegate {
    
    func xzm_tabBar(tabBar: XZMTabbarExtension, didSelectItem index: Int) {
        selectedIndex = index
//        print("sel index: \(selectedIndex)")
        
    }
}
