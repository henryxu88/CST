//
//  MyBusinessViewController.swift
//  CST
//
//  Created by henry on 16/1/25.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import Hokusai
import MMDrawerController
import MJRefresh

class MyBusinessViewController: UIViewController {
    
    //MARK: - Property -
    var prjs = [Proinfo]()
//    var filteredPrjs = [Proinfo]()
    var prjId = ""
    
    var catalog = ProinfoCatalog.PrjsRelated
    var pageIndex = 0   //下一页是第几页
    var property = "name"
    var keyword = ""
    
    var searchController = UISearchController(searchResultsController: nil)
  
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    // menu sheet
    var menuSheet: Hokusai {
        let menu = Hokusai()
        // Add 3 buttons with their selector
        menu.addButton("项目签到", target: self, selector: Selector("button2Pressed"))
        menu.addButton("项目反馈", target: self, selector: Selector("button2Pressed"))
        menu.addButton("项目请假", target: self, selector: Selector("button2Pressed"))
        
        menu.fontName = "Verdana-Bold"
        menu.colorScheme = HOKColorScheme.Hokusai
        
        menu.cancelButtonTitle = "取消"
        // Add a callback for cancel button (Optional)
        menu.cancelButtonAction = {
            menu.dismiss()
        }
        return menu
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addMJHeaderAndFooter()
        tableView.mj_header.beginRefreshing()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = Words.searchPrjs
        
        tableView.tableHeaderView = searchController.searchBar
        
        // set left button : hide main menu
        setupLeftButton()
        

        
        
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
        
        ProinfoApi.getProinfoList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, prjs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                self.pageIndex++
                self.prjs = prjs!
                self.tableView.reloadData()
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        ProinfoApi.getProinfoList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, prjs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if prjs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.prjs.count
                    var indexPaths = [NSIndexPath]()
                    for (i,prj) in prjs!.enumerate() {
                        self.prjs.append(prj)
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
    
    // Selector for button 2
    func button2Pressed() {
        print("button2Pressed")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: - UITableViewDataSource
extension MyBusinessViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return prjs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.prjCellId, forIndexPath: indexPath)
        
        let prj = prjs[indexPath.row]
        cell.textLabel?.text = prj.name
        cell.detailTextLabel?.text = "项目总监： " + prj.chief
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MyBusinessViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        prjId = prjs[indexPath.row].id
        print("prjId: \(prjId)")
        // show menu sheet
        menuSheet.show()
    }
}

// MARK: - UISearchResultsUpdating
extension MyBusinessViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
