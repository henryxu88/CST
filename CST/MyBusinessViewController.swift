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
    
    //MARK: - IBOutlet -
    @IBOutlet weak var tableView: UITableView!
    
    // menu sheet
    var menuSheet: Hokusai {
        let menu = Hokusai()
        // Add 3 buttons with their selector
        menu.addButton("项目签到", target: self, selector: #selector(MyBusinessViewController.prjSignin))
        menu.addButton("项目反馈", target: self, selector: #selector(MyBusinessViewController.showProbackInput))
        menu.addButton("项目请假", target: self, selector: #selector(MyBusinessViewController.showProleaveInput))
        
        menu.fontName = "Verdana-Bold"
        menu.colorScheme = HOKColorScheme.Hokusai
        
        menu.cancelButtonTitle = "取消"
        // Add a callback for cancel button (Optional)
        menu.cancelButtonAction = {
            menu.dismiss()
        }
        return menu
    }
    
    deinit {
        searchController.view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.delegate = self
        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        locService.desiredAccuracy = kCLLocationAccuracyBest
        locService.distanceFilter = 10
        
        //初始化BMKGeoCodeSearch
        geocodeSearch = BMKGeoCodeSearch()
        geocodeSearch.delegate = self
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //启动LocationService
        locService.startUserLocationService()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        //停止LocationService
        locService.stopUserLocationService()
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
    
    // Selector for button 1
    func prjSignin() {
        handleType = 1
        
        lastLocation = locService.userLocation.location
        
        if let location = lastLocation {
            getReverseGeo(location)
        } else {
            displayMessage("无法获得当前位置的经纬度！")
        }
    }
    
    func prjAssign(latitude: String, longitude: String) {
        ProinfoApi.assign(prjId, address: address, latitude: latitude, longitude: longitude, resultClosure: { (isOk,result) -> Void in
            if isOk {
                if let result = result {
                    if result.errorCode == "1" {
                        self.displayMessage(result.errorMessage, withTitle: "提示")
                    } else {
                        self.displayMessage(result.errorMessage)
                    }
                }
            } else {
                self.view.makeToast("项目签到失败，请重新签到")
            }
        })
    }
    
    // Selector for button 2
    func showProbackInput() {
        handleType = 2
        
        lastLocation = locService.userLocation.location
        
        if let location = lastLocation {
            getReverseGeo(location)
        } else {
            displayMessage("无法获得当前位置的经纬度！")
        }
    }
    
    func probackInput(latitude: String, longitude: String) {
        
        ProbackApi.initProbackDetail(prjId) { (isOk, obj) -> Void in
            if isOk {
                if let obj = obj {
                    obj.address = self.address
                    obj.latitude = self.latitudeStr
                    obj.longitude = self.longitudeStr
                    // 跳转到ProbackInputViewController界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProbackInputViewController") as? ProbackInputViewController
                    vc?.proback = obj
                    let nav = UINavigationController(rootViewController: vc!)
                    self.presentViewController(nav, animated: true, completion: nil)
                }
            } else {
                self.view.makeToast("初始化项目反馈表失败，请重新反馈！")
            }

        }
        
    }
    
    // Selector for button 3
    func showProleaveInput() {
        handleType = 3
        
        ProleaveApi.initProleaveDetail(prjId) { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    // 跳转到ProleaveInputViewController界面
                    let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ProleaveInputViewController") as? ProleaveInputViewController
                    vc?.proleave = obj
                    let nav = UINavigationController(rootViewController: vc!)
                    self.presentViewController(nav, animated: true, completion: nil)
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
        
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
//        print("prjId: \(prjId)")
        
        menuSheet.show()    // show menu sheet
    }
}

// MARK: - UISearchResultsUpdating
extension MyBusinessViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}

// MARK: - BMKLocationServiceDelegate
extension MyBusinessViewController: BMKLocationServiceDelegate , BMKGeoCodeSearchDelegate {
    
    //处理位置坐标更新
    func didUpdateBMKUserLocation(userLocation: BMKUserLocation!) {

    }
    
    func getReverseGeo(location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let option = BMKReverseGeoCodeOption()
        let pt = CLLocationCoordinate2DMake(latitude, longitude)
        option.reverseGeoPoint = pt
        
        let result = geocodeSearch.reverseGeoCode(option)
        if result {
//            print("反检索成功")
        } else {
            print("反检索失败")
        }
        
    }

    func onGetReverseGeoCodeResult(searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        if error.rawValue == 0 {    // no error
            
            latitudeStr = "\(lastLocation!.coordinate.latitude)"
            longitudeStr = "\(lastLocation!.coordinate.longitude)"
            
            let addressDetail = result.addressDetail
            var address = ""
            if addressDetail.province == addressDetail.city {
                address = addressDetail.city
            } else {
                address = addressDetail.province + addressDetail.city
            }
            address += addressDetail.district + addressDetail.streetName + addressDetail.streetNumber
            self.address = address
            
            if address.isEmpty {
                displayMessage("无法获得当前位置的地理信息！")
            } else {
                
                if handleType ==  1 {
                    prjAssign(latitudeStr, longitude: longitudeStr)
                } else if handleType == 2 {
                    probackInput(latitudeStr, longitude: longitudeStr)
                }
                
            }
        } else {
            displayMessage("无法获得当前位置的地理信息！")
        }
    }
    
    func didFailToLocateUserWithError(error: NSError!) {
        print("error: \(error)")
    }
    
}