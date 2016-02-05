//
//  CommentListViewController.swift
//  CST
//
//  Created by henry on 16/2/3.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh

class CommentListViewController: UIViewController {
    
    //MARK: - Property -
    var comments = [Comment]()
    var commentId = ""
    var comment: Comment?
    
    var catalog = 6
    var pageIndex = 0   //下一页是第几页

    var keyword = ""
    var targetId = ""
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let cellNib = UINib(nibName: CellManager.commentCellId, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: CellManager.commentCellId)
        
        addMJHeaderAndFooter()
        tableView.mj_header.beginRefreshing()
        
        if catalog == 6 {
            setupLeftButton()
            setupRightButton()
        } else if catalog == 51 {
            setupReturnButton()
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "headerRefresh")
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: "footerRefresh")
    }
    
    
    func headerRefresh() {
        tableView.mj_footer.resetNoMoreData()
        
        pageIndex = 1

        CommentApi.getCommentList(catalog, pageIndex: pageIndex, keyword: keyword, targetId: targetId) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex++
                    self.comments = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    func footerRefresh() {

        
        CommentApi.getCommentList(catalog, pageIndex: pageIndex, keyword: keyword, targetId: targetId) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if objs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.comments.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.comments.append(obj)
                        indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                    }
                    self.pageIndex++
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                }
                
            } else {
                self.tableView.mj_footer.endRefreshing()
                self.view.makeToast(NetManager.requestError)
            }
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "CommentDetail" {
            //            let navController = segue.destinationViewController as! UINavigationController
            //            let controller = navController.topViewController as! ProbackDetailViewController
            //            controller.linkman = proback
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if comment != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(keyId: String) {
//        CommentApi.getProbackDetail(keyId, resultClosure: { (result, obj) -> Void in
//            if result {
//                if let obj = obj {
//                    self.proback = obj
//                    self.performSegueWithIdentifier("CommentDetail", sender: self)
//                }
//            } else {
//                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
//            }
//        })
    }
    
    
}


// MARK: - UITableViewDataSource
extension CommentListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.commentCellId, forIndexPath: indexPath) as! CommentCell
        
        let comment = comments[indexPath.row]
        cell.titleLabel.text = comment.subject
        cell.subTitleLabel.text = "[\(comment.createDate)]"
        cell.rightSubtitleLabel.text = comment.createrName
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CommentListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        commentId = comments[indexPath.row].id
        setDetailObj(commentId)
    }
}

