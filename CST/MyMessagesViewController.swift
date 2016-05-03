//
//  MyMessagesViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import HMSegmentedControl
import MJRefresh

class MyMessagesViewController: UIViewController {
    
    var comments = [Comment]()
    
    var announces = [Announce]()
    
    var probacks = [Proback]()
    
    var catalog = 11     //11:交流 12:公告 13:通知
    var pageIndex = 1   //下一页是第几页
    
    var segmentedControl: HMSegmentedControl!
    var scrollView: UIScrollView!
    var tableView1: UITableView!
    var tableView2: UITableView!
    var tableView3: UITableView!
    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var scrollViewHeight: CGFloat = 0.0
    
    var unreadBtn1: MIBadgeButton!
    var unreadBtn2: MIBadgeButton!
    var unreadBtn3: MIBadgeButton!
    
    @IBOutlet weak var fastButtons: FastButtonsView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.hidesBottomBarWhenPushed = true
        
        // Do any additional setup after loading the view.
        setupLeftButton()
        
        // 设置滑动tab
        viewWidth = CGRectGetWidth(view.bounds)
        viewHeight = CGRectGetHeight(view.bounds)
        scrollViewHeight = viewHeight - 218.0
        setSegmentedControl()
        
        // 设置scrollView
        setScrollView()
        
        // tableView
        setTableView()
        
        // unread btns
        setupUnreadBtn()
        
        // observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyMessagesViewController.markDocReaded), name: "Notification_MarkDocReadedSuccess", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func setupUnreadBtn() {
        let x1 = CGFloat(viewWidth/3 - 50)
        unreadBtn1 = MIBadgeButton(frame: CGRect(x: x1, y: 148, width: 20, height: 20))
        unreadBtn1.badgeString = ""
        unreadBtn1.badgeTextColor = UIColor.whiteColor()
        unreadBtn1.badgeBackgroundColor = UIColor.redColor()
        unreadBtn1.hidden = true
        view.addSubview(unreadBtn1)
        
        let x2 = CGFloat(viewWidth/3*2 - 50)
        unreadBtn2 = MIBadgeButton(frame: CGRect(x: x2, y: 148, width: 20, height: 20))
        unreadBtn2.badgeString = ""
        unreadBtn2.badgeTextColor = UIColor.whiteColor()
        unreadBtn2.badgeBackgroundColor = UIColor.redColor()
        unreadBtn2.hidden = true
        view.addSubview(unreadBtn2)

        let x3 = CGFloat(viewWidth - 50)
        unreadBtn3 = MIBadgeButton(frame: CGRect(x: x3, y: 148, width: 20, height: 20))
        unreadBtn3.badgeString = ""
        unreadBtn3.badgeTextColor = UIColor.whiteColor()
        unreadBtn3.badgeBackgroundColor = UIColor.redColor()
        unreadBtn3.hidden = true
        view.addSubview(unreadBtn3)
    }
    
    func markDocReaded() {
        switch catalog {
        case 11:
            tableView1.mj_header.beginRefreshing()
        case 12:
            tableView2.mj_header.beginRefreshing()
        case 13:
            tableView3.mj_header.beginRefreshing()
        default:
            break
        }
    }
    
    func setSegmentedControl(){
        
        segmentedControl = HMSegmentedControl.init(frame: CGRectMake(0, 134, viewWidth, 44))
        segmentedControl.sectionTitles = [Words.communicate, Words.annonce, Words.notice]
//        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.backgroundColor = Style.barTintTextColor
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont.boldSystemFontOfSize(14)]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : Style.tintColor]
        segmentedControl.selectionIndicatorColor = Style.tintColor
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.tag = 101

        segmentedControl.addTarget(self, action: #selector(MyMessagesViewController.segmentIndexChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)

        view.addSubview(segmentedControl)
        
    }
    
    func setScrollView(){
        scrollView = UIScrollView.init(frame: CGRectMake(0, 178, viewWidth, scrollViewHeight))
        scrollView.backgroundColor = Style.backgroundColor
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(viewWidth * CGFloat(segmentedControl.sectionTitles.count) , scrollViewHeight)
        scrollView.delegate = self
        scrollView.scrollEnabled = false
        
        view.addSubview(scrollView)
    }
    
    func setTableView(){
        
        tableView1 = UITableView(frame: CGRectMake(0, 0, viewWidth, scrollViewHeight))
        tableView1.tag = 801
        tableView1.dataSource = self
        tableView1.delegate = self
        let cellNib1 = UINib(nibName: CellManager.commentCellId, bundle: nil)
        tableView1.registerNib(cellNib1, forCellReuseIdentifier: CellManager.commentCellId)
        tableView1.rowHeight = 66
        
        tableView2 = UITableView(frame: CGRectMake(viewWidth, 0, viewWidth, scrollViewHeight))
        tableView2.tag = 802
        tableView2.dataSource = self
        tableView2.delegate = self
        
        tableView3 = UITableView(frame: CGRectMake(viewWidth * 2, 0, viewWidth, scrollViewHeight))
        tableView3.tag = 803
        tableView3.dataSource = self
        tableView3.delegate = self
        let cellNib3 = UINib(nibName: CellManager.probackCellId, bundle: nil)
        tableView3.registerNib(cellNib3, forCellReuseIdentifier: CellManager.probackCellId)
        tableView3.rowHeight = 66
        
        addMJHeaderAndFooter()
        
        scrollView.addSubview(tableView1)
        scrollView.addSubview(tableView2)
        scrollView.addSubview(tableView3)
        
        tableView1.mj_header.beginRefreshing()
        tableView2.mj_header.beginRefreshing()
        tableView3.mj_header.beginRefreshing()
    }
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        tableView1.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MyMessagesViewController.headerRefresh1))
        tableView1.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MyMessagesViewController.footerRefresh))
        tableView2.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MyMessagesViewController.headerRefresh2))
        tableView2.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MyMessagesViewController.footerRefresh))
        tableView3.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MyMessagesViewController.headerRefresh3))
        tableView3.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MyMessagesViewController.footerRefresh))
    }
    
    
    func headerRefresh1() {
        
        pageIndex = 1
        tableView1.mj_footer.resetNoMoreData()
        CommentApi.getCommentList(11, pageIndex: pageIndex, resultClosure: { (result, objs, numCount) -> Void in
            self.tableView1.mj_header.endRefreshing()
            if result {
                if let objs = objs {
                    self.pageIndex += 1
                    self.comments = objs
                    self.tableView1.reloadData()
                    self.unreadBtn1.badgeString = "\(numCount)"
                    self.unreadBtn1.hidden = false
                } else {
                    self.unreadBtn1.badgeString = ""
                    self.unreadBtn1.hidden = true
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
        
    }
    
    func headerRefresh2() {
        
        pageIndex = 1
        tableView2.mj_footer.resetNoMoreData()
        AnnounceApi.getAnnounceList(12, pageIndex: pageIndex, resultClosure: { (result, objs, numCount) -> Void in
            self.tableView2.mj_header.endRefreshing()
            if result {
                if let objs = objs {
                    self.pageIndex += 1
                    self.announces = objs
                    self.tableView2.reloadData()
                    self.unreadBtn2.badgeString = "\(numCount)"
                    self.unreadBtn2.hidden = false
                } else {
                    self.unreadBtn2.badgeString = ""
                    self.unreadBtn2.hidden = true
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
        
    }
    
    func headerRefresh3() {
        
        pageIndex = 1
        tableView3.mj_footer.resetNoMoreData()
        ProbackApi.getProbackList(13, pageIndex: pageIndex, resultClosure:{ (result, objs, numCount) -> Void in
            self.tableView3.mj_header.endRefreshing()
            if result {
                if let objs = objs {
                    self.pageIndex += 1
                    self.probacks = objs
                    self.tableView3.reloadData()
                    self.unreadBtn3.badgeString = "\(numCount)"
                    self.unreadBtn3.hidden = false
                } else {
                    self.unreadBtn3.badgeString = ""
                    self.unreadBtn3.hidden = true
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
        
    }

        
    func footerRefresh() {
        
        switch catalog {
        case 11:
           
            CommentApi.getCommentList(catalog, pageIndex: pageIndex, resultClosure: { (result, objs, numCount) -> Void in
                self.tableView1.mj_header.endRefreshing()
                if result {
                    if objs == nil {
                        self.tableView1.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        let count = self.comments.count
                        var indexPaths = [NSIndexPath]()
                        for (i,obj) in objs!.enumerate() {
                            self.comments.append(obj)
                            indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                        }
                        self.pageIndex += 1
                        self.tableView1.mj_footer.endRefreshing()
                        self.tableView1.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                       
                    }
                } else {
                    self.tableView1.mj_footer.endRefreshing()
                    self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
                }
            })
        case 12:
            
            AnnounceApi.getAnnounceList(catalog, pageIndex: pageIndex, resultClosure: { (result, objs, numCount) -> Void in
                self.tableView2.mj_header.endRefreshing()
                if result {
                    if objs == nil {
                        self.tableView2.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        let count = self.announces.count
                        var indexPaths = [NSIndexPath]()
                        for (i,obj) in objs!.enumerate() {
                            self.announces.append(obj)
                            indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                        }
                        self.pageIndex += 1
                        self.tableView2.mj_footer.endRefreshing()
                        self.tableView2.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                                            }
                } else {
                    self.tableView2.mj_footer.endRefreshing()
                    self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
                }
            })
        case 13:
            
            ProbackApi.getProbackList(catalog, pageIndex: pageIndex, resultClosure:{ (result, objs, numCount) -> Void in
                self.tableView3.mj_header.endRefreshing()
                if result {
                    if objs == nil {
                        self.tableView3.mj_footer.endRefreshingWithNoMoreData()
                    } else {
                        let count = self.probacks.count
                        var indexPaths = [NSIndexPath]()
                        for (i,obj) in objs!.enumerate() {
                            self.probacks.append(obj)
                            indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                        }
                        self.pageIndex += 1
                        self.tableView3.mj_footer.endRefreshing()
                        self.tableView3.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                       
                    }
                } else {
                    self.tableView3.mj_footer.endRefreshing()
                    self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
                }
            })
            
        default:
            break
        }
            
    }
        
        
    func segmentIndexChanged(segmentedControl: HMSegmentedControl){

        let index = segmentedControl.selectedSegmentIndex
//        print("Selected index: \(index)")
        scrollView.scrollRectToVisible(CGRectMake(viewWidth * CGFloat(index), 0, viewWidth, viewHeight - 148), animated: true)
        
        if index == 0 {
            catalog = 11
            tableView1.mj_header.beginRefreshing()
        } else if index == 1 {
            catalog = 12
            tableView2.mj_header.beginRefreshing()
        } else if index == 2 {
            catalog = 13
            tableView3.mj_header.beginRefreshing()
        } else {
            catalog = 0
        }
        
    }
    
    func setDetailComment(keyword: String, targetId: String, targetClass: String) {
        CommentApi.getCommentList(51, pageIndex: 1, keyword: keyword, targetId: targetId) { (result, comments, numCount) -> Void in
            if result {
                if let comments = comments {
                    // 跳转到交流界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CommentDetailViewController") as? CommentDetailViewController
                    if let vc = vc {
                        vc.comments = comments
                        vc.targetId = targetId
                        vc.targetClass = targetClass
                        vc.keyword = keyword
                        let nav = UINavigationController(rootViewController: vc)
                        self.presentViewController(nav, animated: true, completion: nil)
                    }
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
    }
    
    func setDetailAnnounce(keyId: String) {
        AnnounceApi.getAnnounceDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    // 跳转到公告界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("AnnounceDetailViewController") as? AnnounceDetailViewController
                    if let vc = vc {
                        vc.announce = obj
                        let nav = UINavigationController(rootViewController: vc)
                        self.presentViewController(nav, animated: true, completion: nil)
                    }
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }
    
    func setDetailProback(keyId: String) {
        ProbackApi.getProbackDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    // 跳转到通知界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProbackDetailViewController") as? ProbackDetailViewController
                    if let vc = vc {
                        vc.proback = obj
                        let nav = UINavigationController(rootViewController: vc)
                        self.presentViewController(nav, animated: true, completion: nil)
                    }
                    
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }
        
}

// MARK: - UITableViewDataSource
extension MyMessagesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag {
        case 801:
            return comments.count
        case 802:
            return announces.count
        case 803:
            return probacks.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch tableView.tag {
        case 801:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.commentCellId, forIndexPath: indexPath) as! CommentCell
            
            let comment = comments[indexPath.row]
            cell.titleLabel.text = comment.subject
            cell.subTitleLabel.text = "[\(comment.createDate)] \(comment.text)"
            cell.rightSubtitleLabel.text = comment.createrName
            
            return cell
            
        case 802:
            var cell = tableView.dequeueReusableCellWithIdentifier(CellManager.announceCellId)
            if cell == nil {
                cell = UITableViewCell(style: .Value1, reuseIdentifier: CellManager.announceCellId)
            }
            
            let obj = announces[indexPath.row]
            cell!.textLabel?.text = obj.name
            cell!.detailTextLabel?.text = obj.publishTime
            cell?.detailTextLabel?.font = UIFont.systemFontOfSize(14.0)
            
            return cell!

        case 803:
            let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.probackCellId, forIndexPath: indexPath) as! ProbackCell
            
            let proback = probacks[indexPath.row]
            cell.titleLabel.text = "\(proback.backDate) \(proback.name)"
            cell.subTitleLabel.text = "类别:\(proback.categoryName)  反馈人:\(proback.createrName)"
            cell.rightSubTitleLabel.text = proback.regular
            
            return cell
        default:
            return UITableViewCell()
        }

    }
}

// MARK: - UITableViewDelegate
extension MyMessagesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var keyId = ""
        switch tableView.tag {
        case 801:
            keyId = comments[indexPath.row].id
            let targetId = comments[indexPath.row].targetId
            let targetClass = comments[indexPath.row].targetClass
            setDetailComment(keyId , targetId: targetId, targetClass: targetClass)
            
        case 802:
            keyId = announces[indexPath.row].id
            setDetailAnnounce(keyId)
            
        case 803:
            keyId = probacks[indexPath.row].id
            setDetailProback(keyId)
        default:
            break
        }
        
        if !keyId.isEmpty {
            OtherApi.markRead(keyId) { (result) -> Void in
                if result {
                    NSNotificationCenter.defaultCenter().postNotificationName("Notification_MarkDocReadedSuccess", object: nil)
                } else {
                    self.view.makeToast(NetManager.markReadedError, duration: 3.0, position: .Center)
                }
            }
        }
    }
}