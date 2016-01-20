//
//  MainMenuViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit

class MainMenuViewController: UITableViewController {
    
    let businessMenu = ["客户一览","联系人一览","项目一览","考勤一览","反馈一览","交流一览","公告一览"]
    let settingMenu = ["注销用户","退出应用"]
    let sectionMenu = ["业务" , "设置"]
    let cellID = "MenuCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
        tableView.backgroundColor = MAIN_MENU_BACKGROUND_COLOR
        tableView.separatorStyle = .None
        
        view.backgroundColor = MAIN_MENU_VIEW_BACKGROUND_COLOR
        navigationController?.navigationBar.barTintColor = MAIN_MENU_BAR_COLOR
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : MAIN_MENU_BAR_TITLE_COLOR]
        
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
        switch indexPath.section {
        case 0:
            print("business")
        case 1:
            print("setting")
        default:
            break
        }
    }
}
