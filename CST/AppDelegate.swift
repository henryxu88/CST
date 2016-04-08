//
//  AppDelegate.swift
//  CST
//
//  Created by henry on 16/1/15.
//  Copyright © 2016年 9joint. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController
import AlamofireImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerContainer: MMDrawerController?
    
    var mapManager: BMKMapManager?

    private(set) var currentUser: User?
    private(set) var login = false
    private(set) var loginUid = ""
    private(set) var loginName = ""
    private(set) var loginDigest = ""
    
    let downloader = ImageDownloader()
    let imageCache = AutoPurgingImageCache()
    
    // MARK: - user login related
    func isLogin() -> Bool {
        return login
    }
    
    func saveLoginInfo(user: User) {
        
        currentUser = user
        loginUid = user.id
        loginName = user.username
        loginDigest = user.digest
        login = true
        
        //如果未登录，则设置推送参数
        setAlias()
    }
    
    func cleanLoginInfo() {
        currentUser = nil
        loginUid = ""
        loginName = ""
        loginDigest = ""
        login = false

        // 清除JPush别名
        JPUSHService.setAlias("", callbackSelector: nil, object: self)
    }
    
    func setAlias() {
        if !loginUid.isEmpty {
            JPUSHService.setAlias(loginUid, callbackSelector: #selector(AppDelegate.aliasCallback(_:tags:alias:)), object: self)
        }
    }
    
    func aliasCallback(code: Int32, tags: NSSet?, alias: NSString?){
        switch code {
        case 0:
            print("设置推送（别名）成功!")
        case 6002:
            print("设置推送（别名）超时，20秒后再次尝试")
            self.performSelector(#selector(AppDelegate.setAlias), withObject: nil, afterDelay: 20)
        default:
            print("设置推送（别名）失败")
            break
        }
        
    }

    // MARK: - app life circyle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // location 
        mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数  在此处输入您的授权Key Release: MlgNspG5faWfR7koWpLGtxN1
        let ret = mapManager?.start("xd3uZTc1GUSl8UatHdULp7Mo", generalDelegate: nil)  // 注意此时 ret 为 Bool? 类型
        if let ret = ret where ret {
            print("mapManager start success!")
        } else {
            print("mapManager start failed!")
        }
        
        // JPush : 
        JPUSHService.registerForRemoteNotificationTypes(UIUserNotificationType.Badge.rawValue + UIUserNotificationType.Sound .rawValue + UIUserNotificationType.Alert.rawValue, categories: nil)
        // Release: c7b6e401927f91b143609040
        JPUSHService.setupWithOption(launchOptions, appKey: "9f79c4d603f2050cb7e8ab1c", channel: "App Store", apsForProduction: false)
        
        // custom appearance
        customizeAppearance()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // 重置推送通知
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Remote Notification
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        // Required
        JPUSHService.registerDeviceToken(deviceToken)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // IOS 7+ Support Required
        if (application.applicationState != UIApplicationState.Active) {
            if currentUser == nil {
                // 显示登录界面
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
                let nav = UINavigationController(rootViewController: vc!)
                window?.rootViewController = nav
            } else {
                buildUserInterface()
            }
        }
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.NoData)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("did Fail To Register For Remote Notifications With Error:\(error)")
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        JPUSHService.showLocalNotificationAtFront(notification, identifierKey: nil)
    }
    
    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.9joint.CST" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("CST", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
    // MARK: - appearance
    func customizeAppearance() {
        
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().barTintColor = Style.barTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Style.barTintTextColor]
        
        window!.tintColor = Style.tintColor
        window!.backgroundColor = Style.backgroundColor
    }
    
    // MARK: - build main(home) page
    func buildUserInterface(){

        if login {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let main = storyboard.instantiateViewControllerWithIdentifier("HomePageViewController") as? HomePageViewController
            let left = storyboard.instantiateViewControllerWithIdentifier("MainMenuViewController") as? MainMenuViewController
            
            guard let mainVC = main,leftVC = left else {
                return
            }
            let leftNav = UINavigationController(rootViewController: leftVC)
            
            drawerContainer = MMDrawerController(centerViewController: mainVC, leftDrawerViewController: leftNav)
            drawerContainer?.showsShadow = false
            
            drawerContainer?.maximumLeftDrawerWidth = 240
            drawerContainer?.setDrawerVisualStateBlock(MMDrawerVisualState.slideAndScaleVisualStateBlock())
            drawerContainer?.openDrawerGestureModeMask = .All
            drawerContainer?.closeDrawerGestureModeMask = [.PanningCenterView, .PanningDrawerView, .PanningNavigationBar]

            window?.rootViewController = drawerContainer
        }
    }

}

