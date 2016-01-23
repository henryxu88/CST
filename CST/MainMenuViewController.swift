//
//  MainMenuViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit

class MainMenuViewController: UITableViewController {
    
    let businessMenu = [Words.menuClient,Words.menuLinker,Words.menuProject,Words.menuSignin,Words.menuFeedback,Words.menuCommunicate,Words.menuAnnoncement]
    let settingMenu = [Words.menuUserLogout , Words.menuExitApp]
    let sectionMenu = [Words.menuCategoryBusiness , Words.menuCategorySetting]
    let cellID = "MenuCell"

    override func viewDidLoad() {
        super.viewDidLoad()

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
