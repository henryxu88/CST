//
//  CommentDetailViewController.swift
//  CST
//
//  Created by henry on 16/2/17.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import AlamofireImage

class CommentDetailViewController: JSQMessagesViewController {
    
    // MARK: Properties
    var keyword = ""
    var targetId = ""
    var targetClass = ""
    var userIds = [String]()
    var userNames = [String]()
    
    var avatars = [String : JSQMessagesAvatarImage]()
    var comments = [Comment]()
    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    /**
     设置消息的背景图片
     */
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory.outgoingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleBlueColor())
        incomingBubbleImageView = factory.incomingMessagesBubbleImageWithColor(
            UIColor.jsq_messageBubbleLightGrayColor())
    }
    
    func refreshData() {
        if !comments.isEmpty {
            comments.removeAll()
        }
        
        if !messages.isEmpty {
            messages.removeAll()
        }
        
        CommentApi.getCommentList(51, pageIndex: 1, keyword: keyword, targetId: targetId) { (result, comments, numCount) -> Void in
            if result {
                if let comments = comments {
                    self.comments = comments
                    self.observeMessages()
                }
            } else {
                self.view.makeToast(NetManager.requestError, duration: 3.0, position: .Center)
            }
        }
    }
    
    /**
     获取消息
     */
    private func observeMessages() {
        guard !comments.isEmpty else {
            return
        }
        // 将Comment转化为JSQMessage
        for comment in comments {
            let senderId = comment.createrId
            let senderDisplayName = comment.createrName
            let date = NSDate.fs_dateFromString(comment.createDate, format: "yyyy-MM-dd HH:mm:ss")
            let text = comment.atUsersName + " " + comment.text
            let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
            
            messages.append(message)
            
            // 缓存用户的头像图片
            if !avatars.keys.contains(senderId) {
                
                // 先用缺省图像
                avatars[senderId] = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "no_pic_face"), diameter: JSQMessageContants.kAvatarSizeDefault)
                
                if !comment.createrFace.isEmpty {   // 有头像的URL
                    
                    let URLRequest = NSURLRequest(URL: NSURL(string: comment.createrFace)!)
                    
                    // 先检查是否有缓存
                    let cachedAvatarImage = appDelegate.imageCache.imageForRequest(URLRequest)
                    if cachedAvatarImage == nil {   // 没有缓存

                        appDelegate.downloader.downloadImage(URLRequest: URLRequest) { response in
                            if let imageUser = response.result.value {
                                self.appDelegate.imageCache.addImage(imageUser, forRequest: URLRequest) // add to image cache
                                
                                let image = JSQMessagesAvatarImageFactory.avatarImageWithImage(imageUser, diameter: JSQMessageContants.kAvatarSizeDefault)
                                self.avatars[senderId] = image
                            }
                        }
                        
                    } else {    // 有缓存
                        avatars[senderId] = JSQMessagesAvatarImageFactory.avatarImageWithImage(cachedAvatarImage, diameter: JSQMessageContants.kAvatarSizeDefault)
                    }
                    
                }
                
            }
            
        }
        // 5
        self.finishReceivingMessage()
    }
    
    // MARK: view controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupReturnButton()
        
        senderId = appDelegate.currentUser?.id
        senderDisplayName = appDelegate.currentUser?.name
        
        if targetId.isEmpty {
            observeMessages()
        } else {
            refreshData()
        }
        
        setupBubbles()
        
    }
    
    // MARK: view layout delegate methods
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return JSQMessageContants.kCellTopLabelHeightDefault
    }
    
    // MARK: delegate methods
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
            return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return messages.count
    }
    
    // MARK: data source methods
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
            let message = messages[indexPath.item]
            if message.senderId == senderId {
                return outgoingBubbleImageView
            } else { 
                return incomingBubbleImageView
            }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!,
        avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
            let message = messages[indexPath.item]
            return avatars[message.senderId]
    }
    
    override func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath)
                as! JSQMessagesCollectionViewCell
            
            let message = messages[indexPath.item]
            
            // 显示时间、姓名信息
            var strInfo = JSQMessagesTimestampFormatter.sharedFormatter().timestampForDate(message.date)
            
            if message.senderId == senderId {
                cell.textView!.textColor = UIColor.whiteColor()
            } else {
                cell.textView!.textColor = UIColor.blackColor()
                strInfo = message.senderDisplayName + " " + strInfo
            }
            
            cell.cellTopLabel?.text =  strInfo
            
            return cell
    }
    
    // MARK: business methods
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!,
        senderDisplayName: String!, date: NSDate!) {
            
            if targetId.isEmpty || targetClass.isEmpty {
                displayMessage("该批注的对象不能为空！")
                return
            }
            
            // 生成 tmpcomment
            let tmpcomment = Comment()
            tmpcomment.text = text
            tmpcomment.targetId = targetId
            tmpcomment.targetClass = targetClass
            
            if !userIds.isEmpty {
                tmpcomment.atUsers = userIds.joinWithSeparator(",")
                tmpcomment.atUsersName = userNames.flatMap{ "@" + $0 }.joinWithSeparator(",")
            }
            
            // 发出声音提示
            JSQSystemSoundPlayer.jsq_playMessageSentSound()
            
            // 发送保存请求
            CommentApi.createComment(tmpcomment) { (result) -> Void in
                if result {
                    self.refreshData()
                    self.userIds.removeAll()
                    self.userNames.removeAll()
                    self.finishSendingMessage()
                } else {
                    self.displayMessage(NetManager.requestError)
                }
            }
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        // 跳转到选人界面
        let vc = storyboard!.instantiateViewControllerWithIdentifier("UserPickerViewController") as? UserPickerViewController
        vc?.delegate = self
        
        let nav = UINavigationController(rootViewController: vc!)
        presentViewController(nav, animated: true, completion: nil)
    }
    
}

extension CommentDetailViewController: UserPickerProtocol {
    func getSelectedUsers(users: [UserEasyView]) {
        if !users.isEmpty {
            userIds = UserEasyView.getIds(users)
            userNames = UserEasyView.getNames(users)
        }
    }
}
