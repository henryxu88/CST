//
//  CalendarListViewController.swift
//  CST
//
//  Created by henry on 16/2/4.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh
import FSCalendar

class CalendarListViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate{
    
    //MARK: - Property -
    var eventDates = [NSDate]()             // 有日历事件的日期数组
    var selectedDate = NSDate()             // 选择的日期
    var calendarEvents = [CalendarEvent]()
    var calendarEventId = ""
    var calendarEvent: CalendarEvent?
    
    var catalog = 272
    var pageIndex = 0   //下一页是第几页
    
    var proinfoId = ""
    
    //MARK: - IBOutlet -
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nav bar buttom item
        if proinfoId.isEmpty {
            setupLeftButton()
            setupRightButton()
        } else {
            setupReturnButton()
        }
        
        // calendar
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollDirection = .Vertical
        calendar.firstWeekday = 2
        
        selectedDate = calendar.today
        getEventDates(selectedDate)
        
        // table view
        tableView.dataSource = self
        tableView.delegate = self
        
        addMJHeaderAndFooter()
        tableView.mj_header.beginRefreshing()
        
    }
    
    //MARK: - FSCalendar -
    func getEventDates(date: NSDate){
        
        let startTime = Int64(date.fs_firstDayOfMonth.timeIntervalSince1970 * 1000)
        let endTime = Int64(date.fs_dateByAddingMonths(1).fs_firstDayOfMonth.timeIntervalSince1970 * 1000)

        CalendarEventApi.getEventDateList(catalog, pageIndex: pageIndex, proinfoId: proinfoId, startTime: startTime, endTime: endTime) { (result, objs) -> Void in
            if result {
                if let objs = objs {
                    for calendarDate in objs {
                        if let date = calendarDate.date {
                            if !self.eventDates.contains(date) {
                                self.eventDates.append(date)
                            }
                        }
                    }
                    self.calendar.reloadData()
                }
            }
         }
    }
    
    func calendar(calendar: FSCalendar, hasEventForDate date: NSDate) -> Bool {
        if eventDates.isEmpty {
            return false
        }
        return eventDates.contains(date)
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
//        print("change page to \(calendar.stringFromDate(calendar.currentPage))")    change page to 2015-08-01
        getEventDates(calendar.currentPage)
    }
    
    // FSCalendarDelegate
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        selectedDate = date
        tableView.mj_header.beginRefreshing()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - MJRefresh -
    private func addMJHeaderAndFooter() {
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(CalendarListViewController.headerRefresh))
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(CalendarListViewController.footerRefresh))
    }
    
    
    func headerRefresh() {
        tableView.mj_footer.resetNoMoreData()
        
        pageIndex = 1
        
        let startTime = Int64(selectedDate.timeIntervalSince1970 * 1000)
        let endTime = Int64(selectedDate.fs_dateByAddingDays(1).timeIntervalSince1970 * 1000)
        
        CalendarEventApi.getCalendarEventList(catalog, pageIndex: pageIndex, proinfoId: proinfoId, startTime: startTime, endTime: endTime) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    self.pageIndex += 1
                    self.calendarEvents = objs!
                    self.tableView.reloadData()
                }else {
                    if self.calendarEvents.count>0 {
                        self.calendarEvents.removeAll()
                        self.tableView.reloadData()
                    }
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }

    }
    
    func footerRefresh() {
        
        let startTime = Int64(selectedDate.timeIntervalSince1970 * 1000)
        let endTime = Int64(selectedDate.fs_dateByAddingDays(1).timeIntervalSince1970 * 1000)
        
        CalendarEventApi.getCalendarEventList(catalog, pageIndex: pageIndex, proinfoId: proinfoId, startTime: startTime, endTime: endTime) { (result, objs) -> Void in
            self.tableView.mj_header.endRefreshing()
            if result {
                if objs != nil {
                    let count = self.calendarEvents.count
                    var indexPaths = [NSIndexPath]()
                    for (i,obj) in objs!.enumerate() {
                        self.calendarEvents.append(obj)
                        indexPaths.append(NSIndexPath(forRow: count + i, inSection: 0))
                    }
                    self.pageIndex += 1
                    self.tableView.mj_footer.endRefreshing()
                    self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
                } else  {
                    self.tableView.mj_footer.endRefreshingWithNoMoreData()
                }
            } else {
                self.tableView.mj_footer.endRefreshing()
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProsigninDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ProsigninDetailViewController
            controller.prosignin = sender as! Prosignin
        } else if segue.identifier == "ProleaveDetail" {
            let navController = segue.destinationViewController as! UINavigationController
            let controller = navController.topViewController as! ProleaveDetailViewController
            controller.proleave = sender as! Proleave
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if calendarEvent != nil {
            return true
        }
        return false
    }
    
    func setDetailObj(obj: CalendarEvent) {
        if obj.type == "Leave" {
            // 请假
            ProleaveApi.getProleaveDetail(obj.id, resultClosure: { (result, obj) -> Void in
                if result {
                    if let obj = obj {
                        self.performSegueWithIdentifier("ProleaveDetail", sender: obj)
                    }
                } else {
                    self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
                }
            })
        } else if obj.type == "Signin" {
            // 签到
            ProsigninApi.getProsigninDetail(obj.id, resultClosure: { (result, obj) -> Void in
                if result {
                    if let obj = obj {
                        self.performSegueWithIdentifier("ProsigninDetail", sender: obj)
                    }
                } else {
                    self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
                }
            })
        }
    }
    
}


// MARK: - UITableViewDataSource
extension CalendarListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarEvents.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellManager.calendarEventCellId, forIndexPath: indexPath)
        
        let ce = calendarEvents[indexPath.row]
        cell.textLabel?.text = ce.name
        cell.detailTextLabel?.text = ce.remark
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CalendarListViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        calendarEvent = calendarEvents[indexPath.row]
        setDetailObj(calendarEvent!)
    }
    
}