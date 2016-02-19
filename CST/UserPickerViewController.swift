//
//  UserPickerViewController.swift
//  CST
//
//  Created by henry on 16/2/19.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import THContactPicker

protocol UserPickerProtocol {
    func getSelectedUsers(users: [UserEasyView])
}

class UserPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userPickerView: THContactPickerView!
    var tableView: UITableView!
    var users = [UserEasyView]()
    var selectedUsers = [UserEasyView]()
    var selectedCount: Int {
        return selectedUsers.count
    }
    var filteredUsers = [UserEasyView]()
    var delegate: UserPickerProtocol?
    var limitToOne = false
    
    //MARK: Public methods
    @IBAction func doneButtonTapped(){
        if selectedUsers.isEmpty {
            displayMessage("请至少选择一个用户！")
            return
        }
        delegate?.getSelectedUsers(selectedUsers)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func adjustTableViewInsetTop(topInset: CGFloat, bottom bottomInset: CGFloat){
        tableView.contentInset = UIEdgeInsetsMake(topInset, tableView.contentInset.left, bottomInset, tableView.contentInset.right)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }

    //MARK: Private methods
    private func adjustTableFrame(){
        let yOffset = userPickerView.frame.origin.y + userPickerView.frame.size.height
        let tableFrame = CGRectMake(0, yOffset, view.frame.size.width, view.frame.size.height - yOffset)
        tableView.frame = tableFrame
    }
    
    private func adjustTableViewInsetTop(topInset: CGFloat){
        adjustTableViewInsetTop(topInset, bottom: tableView.contentInset.bottom)
    }
    
    private func adjustTableViewInsetBottom(bottomInset: CGFloat){
        adjustTableViewInsetTop(tableView.contentInset.top, bottom: bottomInset)
    }
    
    private func configureCell(cell: UITableViewCell ,atIndexPath indexPath: NSIndexPath) {
        cell.textLabel?.text =  filteredUsers[indexPath.row].name
        cell.detailTextLabel?.text = filteredUsers[indexPath.row].id
        cell.detailTextLabel?.hidden = true
    }
    
    //MARK: get data methods
    func getUserList() {
        // get users
        UserApi.getUserList(13, pageIndex: 1, property: "", keyword: "") { (result, objs) -> Void in
            if result {
                if objs != nil {
                    self.users = objs!
                    self.filteredUsers = objs!
                    self.tableView.reloadData()
                }
            } else {
                self.view.makeToast(NetManager.requestError)
            }
        }
    }
    
    //MARK: vc life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        // fill layout
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = [UIRectEdge.Bottom, UIRectEdge.Left, UIRectEdge.Right]
        }

        // Initialize and add Contact Picker View
        userPickerView = THContactPickerView.init(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: CGFloat(100.0)))
        userPickerView.autoresizingMask = [UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleWidth]
        userPickerView.delegate = self
        userPickerView.setPlaceholderLabelText(Words.selectUserPlaceholder)
        if limitToOne {
            userPickerView.limitToOne = true
        } else {
            userPickerView.limitToOne = false
        }

        view.addSubview(userPickerView)
        
        let layer = userPickerView.layer
        layer.shadowColor = UIColor(red: 225.0/255.0, green: 226.0/255.0, blue: 228.0/255.0, alpha: 1.0).CGColor
        layer.shadowOffset = CGSizeMake(0, 2)
        layer.shadowOpacity = 1.0
        layer.shadowRadius = 1.0
        
        
        // Fill the rest of the view with the table view
        let y = userPickerView.frame.size.height
        let tableFrame = CGRectMake(0, y, view.frame.size.width, view.frame.size.height - y)
        tableView = UITableView.init(frame: tableFrame, style: UITableViewStyle.Plain)
        tableView.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
 
        tableView.dataSource = self
        tableView.delegate = self
        
        view.insertSubview(tableView, belowSubview: userPickerView)
        
        getUserList()
    }
    
    override func viewDidLayoutSubviews() {
        adjustTableFrame()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        /*Register for keyboard notifications*/
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: UITableViewDataSource, UITableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellManager.userPickerCellId)
        if cell == nil {
            cell = UITableViewCell.init(style: .Value1, reuseIdentifier: CellManager.userPickerCellId)
        }
        
        configureCell(cell!, atIndexPath: indexPath)
        
        if UserEasyView.getIds(selectedUsers).contains(cell!.detailTextLabel!.text!){
            cell?.accessoryType = .Checkmark
        } else {
            cell?.accessoryType = .None
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        let user = filteredUsers[indexPath.row]
        
        // if it is already selected so remove it from
        var hasSelected = 0
        for (index, selectedUser) in selectedUsers.enumerate() {
            if user == selectedUser {
                cell?.accessoryType = .None
                selectedUsers.removeAtIndex(index)
                userPickerView.removeContact(user)
                hasSelected = 1
                break
            }
        }
        
        if hasSelected == 0 {
            cell?.accessoryType = .Checkmark
            selectedUsers.append(user)
            
            var color = UIColor.blueColor()
            let count = selectedUsers.count
            if count % 2 == 0 {
                color = UIColor.orangeColor()
            } else if count % 3 == 0 {
                color = UIColor.purpleColor()
            }
            
            let style = THContactViewStyle.init(textColor: UIColor.whiteColor(), backgroundColor: color, cornerRadiusFactor: CGFloat(2.0))
            let selectedStyle = THContactViewStyle.init(textColor: UIColor.whiteColor(), backgroundColor: UIColor.greenColor(), cornerRadiusFactor: CGFloat(2.0))
            userPickerView.addContact(user, withName: user.name, withStyle: style, andSelectedStyle: selectedStyle)
        }
        
        filteredUsers = users
        tableView.reloadData()
    }
    
    // MARK: NSNotificationCenter
    func keyboardDidShow(notification: NSNotification) {
        let info = notification.userInfo
        
        let kbRect = view.convertRect(info![UIKeyboardFrameEndUserInfoKey]!.CGRectValue, fromView: view.window)
        let h = tableView.frame.origin.y + tableView.frame.size.height - kbRect.origin.y
        adjustTableViewInsetBottom(h)
    }
    
    func keyboardDidHide(notification: NSNotification) {
        let info = notification.userInfo
        
        let kbRect = view.convertRect(info![UIKeyboardFrameEndUserInfoKey]!.CGRectValue, fromView: view.window)
        let h = tableView.frame.origin.y + tableView.frame.size.height - kbRect.origin.y
        adjustTableViewInsetBottom(h)
    }
}

extension UserPickerViewController: THContactPickerDelegate {
    // THContactPickerTextViewDelegate
    func contactPicker(contactPicker: THContactPickerView!, textFieldDidChange textField: UITextField!) {
        let text = textField.text!
        if text.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter{ $0.name.containsString(text) }
        }
        tableView.reloadData()
    }
    
    func contactPicker(contactPicker: THContactPickerView!, textFieldShouldReturn textField: UITextField!) -> Bool {
        return false
    }
    
    func contactPickerDidResize(contactPicker: THContactPickerView!) {
        var frame = tableView.frame
        frame.origin.y = userPickerView.frame.origin.y + userPickerView.frame.size.height
        tableView.frame = frame
    }
    
    func contactPicker(contactPicker: THContactPickerView!, didRemoveContact contact: AnyObject!) {
        let user = contact as! UserEasyView
        selectedUsers = selectedUsers.filter{$0 != user}
        
        let index = users.indexOf(user)
        let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: index!, inSection: 0))
        cell?.accessoryType = .None
    }
    
}