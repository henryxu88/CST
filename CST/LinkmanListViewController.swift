//
//  LinkmanListViewController.swift
//  CST
//
//  Created by henry on 16/1/29.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh

class LinkmanListViewController: UIViewController {
    
    //MARK: - Property -
    var linkmen = [Linkman]()
    var linkmanId = ""
    var linkman: Linkman?
    
    var catalog = 2
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
        
        searchController.searchBar.placeholder = Words.searchLinkmen
        
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
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(LinkmanListViewController.headerRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(LinkmanListViewController.footerRefresh))
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
        
        LinkmanApi.getLinkmanList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex += 1
                    self.linkmen = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        LinkmanApi.getLinkmanList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if objs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.linkmen.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.linkmen.append(obj)
                        indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                    }
                    self.pageIndex += 1
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
        if segue.identifier == "LinkmanDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! LinkmanDetailViewController
            controller.linkman = linkman
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if linkman != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(keyId: String) {
        LinkmanApi.getLinkmanDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    self.linkman = obj
                    self.performSegueWithIdentifier("LinkmanDetail", sender: self)
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        })
    }


}


// MARK: - UITableViewDataSource
extension LinkmanListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return linkmen.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.linkmanCellId, forIndexPath: indexPath)
        
        let linkman = linkmen[indexPath.row]
        cell.textLabel?.text = "\(linkman.name) [\(linkman.duty)]"
        cell.detailTextLabel?.text = linkman.mobile
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension LinkmanListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        linkmanId = linkmen[indexPath.row].id
        setDetailObj(linkmanId)
    }
}

// MARK: - UISearchResultsUpdating
extension LinkmanListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}