//
//  MyKnowledgesViewController.swift
//  CST
//
//  Created by henry on 16/1/20.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh

class MyKnowledgesViewController: UIViewController {
    
    //MARK: - Property -
    var knowledges = [Knowledge]()
    var knowledgeId = ""
    var knowledge: Knowledge?
    
    var catalog = 8
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
        
        KnowledgeApi.getKnowledgeList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex++
                    self.knowledges = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        KnowledgeApi.getKnowledgeList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if objs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.knowledges.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.knowledges.append(obj)
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
        if segue.identifier == "KnowledgeDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! KnowledgeDetailViewController
            controller.knowledge = knowledge
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if knowledge != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(keyId: String) {
        KnowledgeApi.getKnowledgeDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    self.knowledge = obj
                    self.performSegueWithIdentifier("KnowledgeDetail", sender: self)
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        })
    }
    
    
}


// MARK: - UITableViewDataSource
extension MyKnowledgesViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return knowledges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.knowledgeCell, forIndexPath: indexPath)
        
        let obj = knowledges[indexPath.row]
        cell.textLabel?.text = obj.superType + " --> " + obj.subType
        cell.detailTextLabel?.text = "[\(obj.name)]"
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyKnowledgesViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        knowledgeId = knowledges[indexPath.row].id
        setDetailObj(knowledgeId)
    }
}

// MARK: - UISearchResultsUpdating
extension MyKnowledgesViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}