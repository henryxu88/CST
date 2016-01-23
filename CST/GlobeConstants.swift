//
//  GlobeConstants.swift
//  CST
//
//  Created by henry on 16/1/18.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import UIKit

// urls
let HOST = "http://10.10.11.49:8089/"

let BASE_PATH = HOST + "ec-web/app/"

let URL_LOGIN = BASE_PATH + "login.action"


// styles
struct Style{
    // MARK: general style
    static var tintColor = UIColor(red: 52/255, green: 170/255, blue: 220/255, alpha: 1)    //34aadc 文字的颜色

    static var barTintColor = UIColor(red: 0/255, green: 162/255, blue: 237/255, alpha: 1)    //282828 导航条的背景色
    static var barTintTextColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)    //fafafa 导航条的文字颜色
    static var backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)    //ffffff 默认视图的背景色
    
    // MARK: main menu vc style
    static var mainMenuBackgroundColor = UIColor(red: 110/255, green: 113/255, blue: 115/255, alpha: 1)    //6e7173 表格的背景颜色
    static var mainMenuViewBackgroundColor = UIColor(red: 66/255, green: 69/255, blue: 71/255, alpha: 1)    //424547 View的背景色
    static var mainMenuBarColor = UIColor(red: 161/255, green: 164/255, blue: 166/255, alpha: 1)    //a1a4a6 导航条的背景色
    static var mainMenuBarTitleColor = UIColor(red: 55/255, green: 70/255, blue: 77/255, alpha: 1)    //a1a4a6 导航条的文字颜色
    
    
    // MARK: ToDo Table Section Headers
    static var sectionHeaderTitleFont = UIFont(name: "Helvetica-Bold", size: 20)
    static var sectionHeaderTitleColor = UIColor.whiteColor()
    static var sectionHeaderBackgroundColor = UIColor.blackColor()
    static var sectionHeaderBackgroundColorHighlighted = UIColor.grayColor()
    static var sectionHeaderAlpha: CGFloat = 1.0
}

// words
struct Words{
    // MARK: main menu word
    static var menuClient = "菜单一览"
    static var menuLinker = "联系人一览"
    static var menuProject = "项目一览"
    static var menuSignin = "考勤一览"
    static var menuFeedback = "反馈一览"
    static var menuCommunicate = "交流一览"
    static var menuAnnoncement = "公告一览"
    
    static var menuCategoryBusiness = "业务"
    static var menuCategorySetting = "设置"
    
    static var menuUserLogout = "注销用户"
    static var menuExitApp = "退出应用"
    
    // MARK: nav tab title
    static var communicate = "交流"
    static var annonce = "公告"
    static var notice = "通知"
    static var prjsNotFinish = "实施中"
    static var prjsFinished = "已完成"
    static var signin = "签到"
    static var feedback = "反馈"
    static var leave = "请假"
    
    // MARK: tab bar title
    static var myMessages = "我的消息"
    static var currentProjects = "当前项目"
    static var knowledgeShare = "知识共享"
    
    // MARK: tab bar title
    static var prjBasic = "基本信息"
    static var prjComment = "交流信息"
    static var prjSignin = "考勤日历"
    static var prjBack = "反馈列表"
}