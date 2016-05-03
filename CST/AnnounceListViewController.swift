//
//  AnnounceListViewController.swift
//  CST
//
//  Created by henry on 16/2/1.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh

class AnnounceListViewController: UIViewController {
    
    //MARK: - Property -
    var announces = [Announce]()
    var announceId = ""
    var announce: Announce?
    
    var catalog = 7
    var pageIndex = 0   //下一页是第几页
    var property = "name"
    var keyword = ""
    
    var searchController = UISearchController(searchResultsController: nil)
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        addMJHeaderAndFooter()
        tableView.mj_header.beginRefreshing()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = Words.searchAnnounce
        
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // set left button : hide main menu
        setupLeftButton()
        setupRightButton()
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
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(AnnounceListViewController.headerRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(AnnounceListViewController.footerRefresh))
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
        
        AnnounceApi.getAnnounceList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs, numCount) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex += 1
                    self.announces = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        AnnounceApi.getAnnounceList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs, numCount) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if objs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.announces.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.announces.append(obj)
                        indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                    }
                    self.pageIndex += 1
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                }
                
            } else {
                self.tableView.mj_footer.endRefreshing()
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
        
    }
    
    func filterContentForSearchText(searchText: String) {
        headerRefresh()
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AnnounceDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! AnnounceDetailViewController
            controller.announce = announce
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if announce != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(keyId: String) {
        AnnounceApi.getAnnounceDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    self.announce = obj
                    self.performSegueWithIdentifier("AnnounceDetail", sender: self)
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }
    
    
}


// MARK: - UITableViewDataSource
extension AnnounceListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announces.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.announceCellId, forIndexPath: indexPath)
        
        let obj = announces[indexPath.row]
        cell.textLabel?.text = obj.name
        cell.detailTextLabel?.text = obj.publishTime
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AnnounceListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        announceId = announces[indexPath.row].id
        setDetailObj(announceId)
    }
}

// MARK: - UISearchResultsUpdating
extension AnnounceListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}