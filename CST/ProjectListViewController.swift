//
//  MyProjectsViewController.swift
//  
//
//  Created by henry on 16/1/20.
//
//

import UIKit
import MMDrawerController
import HMSegmentedControl
import MJRefresh

class ProjectListViewController: UIViewController {
    
    //MARK: - Property -
    var proinfos = [Proinfo]()
    var proinfoId = ""
    var proinfo: Proinfo?
    
    var catalog = ProinfoCatalog.PrjsNotFinish     //1:实施中 2:已完成
    var pageIndex = 0   //下一页是第几页
    var property = "name"
    var keyword = ""
    
    var segmentedControl: HMSegmentedControl!
    var scrollView: UIScrollView!
    var tableView: UITableView!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var scrollViewHeight: CGFloat = 0.0
    
    deinit {
        searchController.view.removeFromSuperview()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupLeftButton()
        setupRightButton()
        
        // 设置滑动tab
        viewWidth = CGRectGetWidth(view.bounds)
        viewHeight = CGRectGetHeight(view.bounds)
        scrollViewHeight = viewHeight - 108.0
        setSegmentedControl()
        
        // 设置scrollView
        setScrollView()
        
        // tableView
        setTableView()

    }
    
    func setSegmentedControl(){
        
        segmentedControl = HMSegmentedControl.init(frame: CGRectMake(0, 64, viewWidth, 44))
        segmentedControl.sectionTitles = [Words.prjsNotFinish, Words.prjsFinished]
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.backgroundColor = Style.barTintTextColor
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont.boldSystemFontOfSize(14)]
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName : Style.tintColor]
        segmentedControl.selectionIndicatorColor = Style.tintColor
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown
        segmentedControl.tag = 101
        
        segmentedControl.indexChangeBlock = { [weak self] in self?.segmentIndexChanged($0) }
        view.addSubview(segmentedControl)

    }
    
    func setScrollView(){
        scrollView = UIScrollView.init(frame: CGRectMake(0, 108, viewWidth, scrollViewHeight))
        scrollView.backgroundColor = Style.backgroundColor
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSizeMake(viewWidth * CGFloat(segmentedControl.sectionTitles.count) , scrollViewHeight)
        scrollView.delegate = self
        scrollView.scrollEnabled = false
        
        view.addSubview(scrollView)
    }
    
    func setTableView(){
        
        tableView = UITableView(frame: CGRectMake(0, 0, viewWidth, scrollViewHeight))
        tableView.dataSource = self
        tableView.delegate = self
        
        addMJHeaderAndFooter()
        tableView.mj_header.beginRefreshing()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        searchController.searchBar.placeholder = Words.searchPrjs
        
        tableView.tableHeaderView = searchController.searchBar
        
        scrollView.addSubview(tableView)
    }
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(ProjectListViewController.headerRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(ProjectListViewController.footerRefresh))
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
        
        ProinfoApi.getProinfoList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex += 1
                    self.proinfos = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
    }
    
    func footerRefresh() {
        getKeyWord()
        
        ProinfoApi.getProinfoList(catalog, pageIndex: pageIndex, property: property, keyword: keyword) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                
                if objs == nil {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                } else {
                    let count = self.proinfos.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.proinfos.append(obj)
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
    
    func segmentIndexChanged(index: Int){
//        print("Selected index: \(index)")
        if index == 1 {
            catalog = ProinfoCatalog.PrjsFinished
        } else {
            catalog = ProinfoCatalog.PrjsNotFinish
        }
        
        headerRefresh()
        
        let x = viewWidth * CGFloat(index)
        let y = tableView.frame.origin.y
        let point = CGPoint(x: x, y: y)
        tableView.frame.origin = point
        
        self.scrollView.scrollRectToVisible(CGRectMake(x, 0, viewWidth, scrollViewHeight), animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProjectDetail" {
            let controller = segue.destinationViewController as! ProjectTabBarContoller
            controller.proinfo = proinfo
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if proinfo != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(keyId: String) {
        ProinfoApi.getProinfoDetail(keyId, resultClosure: { (result, obj) -> Void in
            if result {
                if let obj = obj {
                    self.proinfo = obj
                    self.performSegueWithIdentifier("ProjectDetail", sender: self)
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        })
    }

}

//extension ProjectListViewController: UIScrollViewDelegate {
//    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        let pageWidth = scrollView.bounds.width
//        let page = scrollView.contentOffset.x / pageWidth
//        let index = UInt(page)
//        segmentIndexChanged(Int(index))
//        
//        segmentedControl.setSelectedSegmentIndex(index, animated: true)
//    }
//}

// MARK: - UITableViewDataSource
extension ProjectListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return proinfos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CellManager.prjCellId)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: CellManager.prjCellId)
        }
        
        let obj = proinfos[indexPath.row]
        cell!.textLabel?.text = obj.name
        cell!.detailTextLabel?.text = "项目总监：\(obj.chief)"
        
        return cell!
    }
}

// MARK: - UITableViewDelegate
extension ProjectListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        proinfoId = proinfos[indexPath.row].id
        setDetailObj(proinfoId)
    }
}

// MARK: - UISearchResultsUpdating
extension ProjectListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
