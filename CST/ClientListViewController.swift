//
//  ClientListViewController.swift
//  CST
//
//  Created by henry on 16/1/28.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh

class ClientListViewController: UIViewController {
    
    //MARK: - Property -
    var clients = [Client]()
    var clientId = ""
    
    var catalog = 1
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
        
        searchController.searchBar.placeholder = Words.searchClients
        
        tableView.tableHeaderView = searchController.searchBar
        
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
        
        ClientApi.getClientList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, clients) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if clients != nil {
                    self.pageIndex++
                    self.clients = clients!
                    self.tableView.reloadData()
                } 
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        ClientApi.getClientList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, clients) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if clients == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.clients.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in clients!.enumerate() {
                        self.clients.append(obj)
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
    
    //MARK: - 设置系统菜单的显示／隐藏 -
    func setupLeftButton(){
        let btn = MMDrawerBarButtonItem.init(target: self, action: "hideMenuButtonTapped")
        btn.tintColor = UIColor.whiteColor()
        navigationItem.setLeftBarButtonItem(btn, animated: true)
    }
    
    func hideMenuButtonTapped() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.toggleDrawerSide(.Left, animated: true, completion: nil)
    }
    
    //MARK: - 设置返回主界面
    func setupRightButton(){
        let btn = MMDrawerBarButtonItem.init(target: self, action: "returnHomeButtonTapped")
        btn.tintColor = UIColor.whiteColor()
        navigationItem.setRightBarButtonItem(btn, animated: true)
    }
    
    func returnHomeButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as? HomePageViewController
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.drawerContainer?.setCenterViewController(main, withCloseAnimation: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource
extension ClientListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return clients.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.clientCellId, forIndexPath: indexPath)
        
        let client = clients[indexPath.row]
        cell.textLabel?.text = client.name
        cell.detailTextLabel?.text = client.typeName
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ClientListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        clientId = clients[indexPath.row].id
        print("clientId : \(clientId)")
        // show menu sheet
        
    }
}

// MARK: - UISearchResultsUpdating
extension ClientListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
