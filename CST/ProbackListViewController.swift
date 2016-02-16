//
//  ProbackListViewController.swift
//  CST
//
//  Created by henry on 16/2/2.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh

class ProbackListViewController: UIViewController {
    
    //MARK: - Property -
    var probacks = [Proback]()
    var probackId = ""
    var proback: Proback?
    
    var catalog = 5
    var pageIndex = 0   //下一页是第几页
    var property = "name"
    var keyword = ""
    var proinfoId = ""
    
    var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        let cellNib = UINib(nibName: CellManager.probackCellId, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: CellManager.probackCellId)
        
        addMJHeaderAndFooter()
        tableView.mj_header.beginRefreshing()
        
        if catalog == 13 {
            return  // 和我相关的反馈列表没有搜索栏
        }
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        if catalog == 5 {
            searchController.searchBar.placeholder = Words.searchPrjs
            setupLeftButton()
            setupRightButton()
        } else if catalog == 9 {
            searchController.searchBar.placeholder = Words.searchProback
            setupReturnButton()
        }
        
        tableView.tableHeaderView = searchController.searchBar
 
    }
    
    deinit {
        searchController.view.removeFromSuperview()
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
    
    func getKeyWord() {
        if searchController.active && searchController.searchBar.text != "" {
            keyword = searchController.searchBar.text!
        } else {
            keyword = ""
        }
    }
    
    func headerRefresh() {
        tableView.mj_footer.resetNoMoreData()
        
        pageIndex = 1
        getKeyWord()
        
        ProbackApi.getProbackList(catalog, pageIndex: pageIndex, property: property, keyword: keyword, proinfoId: proinfoId) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex++
                    self.probacks = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        ProbackApi.getProbackList(catalog, pageIndex: pageIndex, property: property, keyword: keyword, proinfoId: proinfoId) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if objs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.probacks.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.probacks.append(obj)
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
    
    func filterContentForSearchText(searchText: String) {
        headerRefresh()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProbackDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ProbackDetailViewController
            controller.proback = sender as! Proback
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if sender != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(keyId: String) {
        ProbackApi.getProbackDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
//                    self.proback = obj
                    self.performSegueWithIdentifier("ProbackDetail", sender: obj)
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }
    
    
}


// MARK: - UITableViewDataSource
extension ProbackListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return probacks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.probackCellId, forIndexPath: indexPath) as! ProbackCell
        
        let proback = probacks[indexPath.row]
        cell.titleLabel.text = "\(proback.backDate) \(proback.name)"
        cell.subTitleLabel.text = "类别:\(proback.categoryName)  反馈人:\(proback.createrName)"
        cell.rightSubTitleLabel.text = proback.regular
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProbackListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        probackId = probacks[indexPath.row].id
        setDetailObj(probackId)
    }
}

// MARK: - UISearchResultsUpdating
extension ProbackListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
