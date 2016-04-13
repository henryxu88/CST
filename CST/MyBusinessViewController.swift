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
    var prjId = ""
    
    var catalog = ProinfoCatalog.PrjsRelated
    var pageIndex = 0   //下一页是第几页
    var property = "name"
    var keyword = ""
    
    var handleType = 0
    
    var searchController = UISearchController(searchResultsController: nil)
  
    var locService: BMKLocationService!
    var geocodeSearch: BMKGeoCodeSearch!
    var lastLocation: CLLocation?
    var address = ""
    var latitudeStr = ""
    var longitudeStr = ""
    
    @IBOutlet weak var fastButtons: FastButtonsView!
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    deinit {
        searchController.view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table
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
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(MyBusinessViewController.headerRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MyBusinessViewController.footerRefresh))
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
                if prjs != nil {
                    self.pageIndex += 1
                    self.prjs = prjs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
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
        
        ProinfoApi.getProinfoDetail(prjId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    //跳转到项目界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProjectTabBarContoller") as? ProjectTabBarContoller
                    if let vc = vc {
                        vc.proinfo = obj
                        self.presentViewController(vc, animated: true, completion: nil)
                    }
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }
}

// MARK: - UISearchResultsUpdating
extension MyBusinessViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}