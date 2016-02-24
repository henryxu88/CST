//
//  GlobeConstants.swift
//  CST
//
//  Created by henry on 16/1/18.
//  Copyright © 2016年 9joint. All rights reserved.
//

import Foundation
import UIKit

//JSQMessage
struct JSQMessageContants {
    static let kCellTopLabelHeightDefault = CGFloat(25.0)
    static let kAvatarSizeDefault = UInt(30)
}

// catalog related
enum ProinfoCatalog {
    case PrjsAll
    case PrjsRelated
    case PrjsNotFinish
    case PrjsFinished
}

// cell related
struct CellManager {
    static let prjCellId = "ProjectCell"
    static let clientCellId = "ClientCell"
    static let linkmanCellId = "LinkmanCell"
    static let probackCellId = "ProbackCell"
    static let announceCellId = "AnnounceCell"
    static let knowledgeCell = "KnowledgeCell"
    static let commentCellId = "CommentCell"
    static let resumeCellId = "ResumeCell"
    static let calendarEventCellId = "CalendarEventCell"
    static let userPickerCellId = "UserPickerCell"
}

// urls
struct NetManager {
    static let HOST = "http://10.10.11.49:8089/"
    static let BASE_PATH = HOST + "ec-web/app/"
    static let BASE_PATH_COM = HOST + "ec-web/com/"
    
    static let URL_LOGIN = BASE_PATH + "login.action"
    
    static let USER_LIST = "users!getList.action"
    
    static let FILE_PUBLIC = BASE_PATH_COM + "file.action"
    
    static let MARK_DOC_READED = "readinfo!create.action"
    
    static let CLIENT_LIST = "client!getList.action"
    static let CLIENT_DETAIL = "client!getDetail.action"
    
    static let LINKMAN_LIST = "linkman!getList.action"
    static let LINKMAN_DETAIL = "linkman!getDetail.action"
    
    static let PROINFO_LIST = "proinfo!getList.action"
    static let PROINFO_DETAIL = "proinfo!getDetail.action"
    static let PROINFO_LIST_RELATED = "proinfo!getListRelated.action"   // 与我相关的项目
    
    static let PROBACK_LIST = "proback!getList.action"
    static let PROBACK_LIST_PROINFO = "proback!getListAboutProinfo.action"  // 某一个项目下的反馈列表
    static let PROBACK_LIST_ABOUTME = "proback!getListAboutMe.action"  // 和我相关的的反馈列表
    static let PROBACK_DETAIL = "proback!getDetail.action"
    static let PROBACK_PHOTO_UPLOAD = "proback!uploadPhoto.action"
    static let PROBACK_CREATE = "proback!create.action"
    static let PROBACK_INIT = "proback!initDetail.action"
    
    static let RESUME_LIST = "resume!getList.action"
    
    static let ANNOUNCE_LIST = "announce!getList.action"
    static let ANNOUNCE_DETAIL = "announce!getDetail.action"
    static let ANNOUNCE_LIST_RELATED = "announce!getListRelated.action"   // 与我相关的项目
    
    static let KNOWLEDGE_LIST = "knowledge!getList.action"
    static let KNOWLEDGE_DETAIL = "knowledge!getDetail.action"
    static let KNOWLEDGE_WEBVIEW = BASE_PATH + "knowledge!webview.action?keyId="
    static let KNOWLEDGE_FILEVIEW = "knowledge!fileview.action"
    
    static let COMMENT_LIST = "comment!getList.action"
    static let COMMENT_LIST_TARGET = "comment!getAboutTargetList.action"  // 某一个文档下的批注
    static let COMMENT_LIST_ABOUTME = "comment!getAboutMeList.action"  // 和我相关的的批注
    static let COMMENT_CREATE = "comment!create.action"
    
    static let CALENDAR_LIST = "users!getCalendarList.action"           // 某一个天下的日历事件列表
    static let CALENDAR_DATE_LIST = "users!getCalendarDateList.action"  // 某一个月下的有日历事件的日期列表
    
    static let PROSIGNIN_DETAIL = "prosignin!getDetail.action"
    
    static let PROLEAVE_DETAIL = "proleave!getDetail.action"
    static let PROLEAVE_CREATE = "proleave!create.action"
    static let PROLEAVE_INIT = "proleave!initDetail.action"
    
    static let requestSending = "正在发送......"
    static let netError = "网络异常，请检查网络"
    static let requestError = "请求数据失败"
    static let markReadedError = "标记文档已读出错"
    static let requestSuccess = "操作成功"
    static let pageSize = 20
    static let pageSizeTargetComments = 100
}


// styles
struct Style{
    // MARK: general style
    static var tintColor = UIColor(red: 52/255, green: 170/255, blue: 220/255, alpha: 1)    //34aadc 文字的颜色
    static var tintColorHalfAlpha = UIColor(red: 52/255, green: 170/255, blue: 220/255, alpha: 0.2)    //34aadc 文字的颜色 alpha：0.2

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
    static var menuClient = "客户一览"
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
    static var myBusiness = "我的业务"
    static var aboutUs = "关于我们"
    
    // MARK: tab bar title
    static var prjBasic = "基本信息"
    static var prjComment = "交流信息"
    static var prjSignin = "考勤日历"
    static var prjBack = "反馈列表"
    
    // MARK: search bar placeholder
    static var searchPrjs = "搜索项目名称"
    static var searchClients = "搜索客户名称"
    static var searchLinkmen = "搜索姓名"
    static var searchAnnounce = "搜索公告名称"
    static var searchProback = "搜索反馈内容"
    
    static var selectUser = "选择人员"
    static var selectUserPlaceholder = "已选择人员列表"
}