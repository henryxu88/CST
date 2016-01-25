//
//  HomePageViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit

class HomePageViewController: UITabBarController , XZMTabbarExtensionDelegate {

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

        /** 添加子控制器 */
        let vc1 = MyMessagesViewController()
        tabBarChildViewController(vc1, norImage: UIImage(named: "tab_bar_message_nor")!, selImage: UIImage(named: "tab_bar_message")! , title: Words.myMessages)
        
        let vc2 = MyProjectsViewController()
        tabBarChildViewController(vc2, norImage: UIImage(named: "tab_bar_project_nor")!, selImage: UIImage(named: "tab_bar_project")! , title: Words.currentProjects)
        
        let vc3 = MyKnowledgesViewController()
        tabBarChildViewController(vc3, norImage: UIImage(named: "tab_bar_knowledge_nor")!, selImage: UIImage(named: "tab_bar_knowledge")! , title: Words.knowledgeShare)
        
        let vc4 = MyMessagesViewController()
        tabBarChildViewController(vc4, norImage: UIImage(named: "tab_bar_knowledge_nor")!, selImage: UIImage(named: "tab_bar_knowledge")! , title: Words.createHandle)
        
        setTabBar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBarChildViewController(vc: UIViewController, norImage: UIImage, selImage: UIImage, title: String){
        /** 创建导航控制器 */
        let nav = UINavigationController.init(rootViewController: vc)
        vc.title = title
        /** 创建模型 */
        let tabBarItem = UITabBarItem()
        tabBarItem.image = norImage
        tabBarItem.selectedImage = selImage
        
        /** 添加到模型数组 */
        itemArray.append(tabBarItem)
        self.addChildViewController(nav)
    }
    
    /** 代理方法 */
    func xzm_tabBar(tabBar: XZMTabbarExtension, didSelectItem index: Int) {
        selectedIndex = index
        print("sel index: \(selectedIndex)")
    }
    
    func setTabBar(){
        /** 创建自定义tabbar */
        let tabBar = XZMTabbarExtension()
        tabBar.backgroundColor = Style.barTintTextColor
        tabBar.frame = self.tabBar.bounds
        /** 传递模型数组 */
        tabBar.items = self.itemArray
        tabBar.xzm_setShadeItemBackgroundColor(Style.tintColorHalfAlpha)
        
        /** 设置代理 */
        tabBar.delegate = self
        
        self.tabBar.addSubview(tabBar)
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
