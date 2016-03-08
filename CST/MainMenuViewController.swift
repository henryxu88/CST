//
//  MainMenuViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController

class MainMenuViewController: UITableViewController {
    
    var menuText = ""
    let businessMenu = [Words.menuClient,Words.menuLinker,Words.menuProject,Words.menuSignin,Words.menuFeedback,Words.menuCommunicate,Words.menuAnnoncement]
    let settingMenu = [Words.menuUserLogout , Words.menuExitApp]
    let sectionMenu = [Words.menuCategoryBusiness , Words.menuCategorySetting]
    let cellID = "MenuCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.selectedIndex = 0

        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        tableView.backgroundColor = Style.mainMenuBackgroundColor
        tableView.separatorStyle = .None
        
        view.backgroundColor = Style.mainMenuViewBackgroundColor
        navigationController?.navigationBar.barTintColor = Style.mainMenuBarColor
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Style.mainMenuBarTitleColor]
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionMenu.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return businessMenu.count
        } else if section == 1 {
            return settingMenu.count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = businessMenu[indexPath.row]
        case 1:
            cell.textLabel?.text = settingMenu[indexPath.row]
        default:
            break
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionMenu[section]
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = MenuSectionHeaderView(frame: CGRectMake(0, 0, CGRectGetWidth(tableView.bounds), 56.0))
        headView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        headView.setSectionTitle(sectionMenu[section])
        return headView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 56.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40.0
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        menuText = cell?.textLabel?.text ?? ""
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch indexPath.section {
        case 0:
            switch menuText {
            case Words.menuClient:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("ClientListViewController") as? ClientListViewController
                
                setViewController(vc)
                
            case Words.menuLinker:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("LinkmanListViewController") as? LinkmanListViewController
                
                setViewController(vc)
                
            case Words.menuProject:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("ProjectListViewController") as? ProjectListViewController
                
                setViewController(vc)
                
            case Words.menuSignin:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("CalendarListViewController") as? CalendarListViewController
                
                setViewController(vc)
                
            case Words.menuFeedback:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("ProbackListViewController") as? ProbackListViewController
                
                setViewController(vc)
                
            case Words.menuCommunicate:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("CommentListViewController") as? CommentListViewController
                
                setViewController(vc)
                
            case Words.menuAnnoncement:
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("AnnounceListViewController") as? AnnounceListViewController
                
                setViewController(vc)
                
            default:
                break
            }
//            print("business:\(menuText)")
        case 1:
//            print("setting:\(menuText)")
            switch menuText {
            case Words.menuUserLogout:
                logoutApp()
            case Words.menuExitApp:
                exitApp()
            default:
                break
            }
        default:
            break
        }
    }
    
    func logoutApp(){
        let alertController = UIAlertController(title: "退出当前账号", message: "确定退出当前账号吗？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {(action) -> () in
            
            // 用户注销
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.cleanLoginInfo()
            if let drawer = appDelegate.drawerContainer {
                drawer.toggleDrawerSide(.Left, animated: true, completion: nil)
            }
            // 显示登录界面
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
            let nav = UINavigationController(rootViewController: vc!)
            self.presentViewController(nav, animated: true, completion: nil)
            
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler:nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func exitApp(){
        let alertController = UIAlertController(title: "退出", message: "确定退出应用吗？", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "确定", style: .Default, handler: {(action) -> () in
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            if let drawer = appDelegate.drawerContainer {
                drawer.toggleDrawerSide(.Left, animated: true, completion: nil)
            }
            UIControl().sendAction(Selector("suspend"), to: UIApplication.sharedApplication(), forEvent: nil)
        })
        let cancelAction = UIAlertAction(title: "取消", style: .Default, handler:nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setViewController(vc: UIViewController?) {
        if let vc = vc {
            vc.title = menuText
            let nav = UINavigationController(rootViewController: vc)
            setCenterController(nav)
        } else {
            return
        }
    }
    
    func setCenterController(nav: UINavigationController){
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let drawer = appDelegate.drawerContainer {
            drawer.setCenterViewController(nav, withCloseAnimation: true, completion: nil)
            drawer.toggleDrawerSide(.Left, animated: true, completion: nil)
        }
    }
}
