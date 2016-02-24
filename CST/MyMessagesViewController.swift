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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupLeftButton()
        
        // 设置滑动tab
        viewWidth = CGRectGetWidth(view.bounds)
        viewHeight = CGRectGetHeight(view.bounds)
        scrollViewHeight = viewHeight - 148.0
        setSegmentedControl()
        
        // 设置scrollView
        setScrollView()
        
        // tableView
        setTableView()
        
        // observer
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "markDocReaded", name: "Notification_MarkDocReadedSuccess", object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        
        segmentedControl = HMSegmentedControl.init(frame: CGRectMake(0, 64, viewWidth, 40))
        segmentedControl.sectionTitles = [Words.communicate, Words.annonce, Words.notice]
//        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.backgroundColor = Style.barTintTextColor
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont.boldSystemFontOfSize(14)]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : Style.tintColor]
        segmentedControl.selectionIndicatorColor = Style.tintColor
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone
        segmentedControl.tag = 101
        
//        let button = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        button.badgeString = "120"
//        button.badgeEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 15)
//        button.badgeTextColor = UIColor.whiteColor()
//        button.badgeBackgroundColor = UIColor.redColor()
//        segmentedControl.scrollView.addSubview(button)
//        view.addSubview(button)

        segmentedControl.addTarget(self, action: "segmentIndexChanged:", forControlEvents: UIControlEvents.ValueChanged)

        view.addSubview(segmentedControl)
        
    }
    
    func setScrollView(){
        scrollView = UIScrollView.init(frame: CGRectMake(0, 104, viewWidth, scrollViewHeight))
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
        tableView1.mj_header.beginRefreshing()
        
        scrollView.addSubview(tableView1)
        scrollView.addSubview(tableView2)
        scrollView.addSubview(tableView3)
    }
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        tableView1.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        tableView1.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
        tableView2.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        tableView2.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
        tableView3.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        tableView3.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
    }
    
    
    func headerRefresh() {
        
        pageIndex = 1
        
        switch catalog {
        case 11:
            tableView1.mj_footer.resetNoMoreData()
            CommentApi.getCommentList(catalog, pageIndex: pageIndex, resultClosure: { (result, objs) -> Void in
                self.tableView1.mj_header.endRefreshing()
                if result {
                    if objs != nil {
                        self.pageIndex++
                        self.comments = objs!
                        self.tableView1.reloadData()
                        
                    }
                } else {
                    self.view.makeToast(NetManager.requestError)
                }
            })
        case 12:
            tableView2.mj_footer.resetNoMoreData()
            AnnounceApi.getAnnounceList(catalog, pageIndex: pageIndex, resultClosure: { (result, objs) -> Void in
                self.tableView2.mj_header.endRefreshing()
                if result {
                    if objs != nil {
                        self.pageIndex++
                        self.announces = objs!
                        self.tableView2.reloadData()
                        
                    }
                } else {
                    self.view.makeToast(NetManager.requestError)
                }
            })
        case 13:
            tableView3.mj_footer.resetNoMoreData()
            ProbackApi.getProbackList(catalog, pageIndex: pageIndex, resultClosure:{ (result, objs) -> Void in
                self.tableView3.mj_header.endRefreshing()
                if result {
                    if objs != nil {
                        self.pageIndex++
                        self.probacks = objs!
                        self.tableView3.reloadData()
                        
                    }
                } else {
                    self.view.makeToast(NetManager.requestError)
                }
            })

        default:
            break
        }
    }
    
        
    func footerRefresh() {
        
        switch catalog {
        case 11:
           
            CommentApi.getCommentList(catalog, pageIndex: pageIndex, resultClosure: { (result, objs) -> Void in
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
                        self.pageIndex++
                        self.tableView1.mj_footer.endRefreshing()
                        self.tableView1.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                       
                    }
                } else {
                    self.tableView1.mj_footer.endRefreshing()
                    self.view.makeToast(NetManager.requestError)
                }
            })
        case 12:
            
            AnnounceApi.getAnnounceList(catalog, pageIndex: pageIndex, resultClosure: { (result, objs) -> Void in
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
                        self.pageIndex++
                        self.tableView2.mj_footer.endRefreshing()
                        self.tableView2.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                                            }
                } else {
                    self.tableView2.mj_footer.endRefreshing()
                    self.view.makeToast(NetManager.requestError)
                }
            })
        case 13:
            
            ProbackApi.getProbackList(catalog, pageIndex: pageIndex, resultClosure:{ (result, objs) -> Void in
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
                        self.pageIndex++
                        self.tableView3.mj_footer.endRefreshing()
                        self.tableView3.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                       
                    }
                } else {
                    self.tableView3.mj_footer.endRefreshing()
                    self.view.makeToast(NetManager.requestError)
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
        CommentApi.getCommentList(51, pageIndex: 1, keyword: keyword, targetId: targetId) { (result, comments) -> Void in
            if result {
                if let comments = comments {
                    // 跳转到公告界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("CommentDetailViewController") as? CommentDetailViewController
                    vc?.comments = comments
                    vc?.targetId = targetId
                    vc?.targetClass = targetClass
                    vc?.keyword = keyword
                    let nav = UINavigationController(rootViewController: vc!)
                    self.presentViewController(nav, animated: true, completion: nil)
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
                    vc?.announce = obj
                    let nav = UINavigationController(rootViewController: vc!)
                    self.presentViewController(nav, animated: true, completion: nil)
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
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProbackDetailViewController") as? ProbackDetailViewController
                    vc?.proback = obj
                    let nav = UINavigationController(rootViewController: vc!)
                    self.presentViewController(nav, animated: true, completion: nil)
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
            cell.subTitleLabel.text = "[\(comment.createDate)]"
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