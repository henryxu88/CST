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
import SwiftFilePath
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
    
    private(set) var saveImagePath = ""
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
//        setJPushAlias(user.id)
   
    }
    
    func cleanLoginInfo() {
        currentUser = nil
        loginUid = ""
        loginName = ""
        loginDigest = ""
        login = false
    }

    // MARK: - app life circyle
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // set save image path
        saveImagePath = Path.documentsDir.toString() + "/images/"
        
        // iamge loader : initImageLoader(self)
        
        // location : MainLocationManager.init(this)
        mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数  在此处输入您的授权Key
        let ret = mapManager?.start("MlgNspG5faWfR7koWpLGtxN1", generalDelegate: nil)  // 注意此时 ret 为 Bool? 类型
        if let ret = ret where ret {
            print("mapManager start success!")
        } else {
            print("mapManager start failed!")
        }
                
        // JPush : 
        
        customizeAppearance()
        
        //        buildUserInterface()
        
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
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
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
        
        
        UINavigationBar.appearance().barTintColor = Style.barTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: Style.barTintTextColor]
        
        window!.tintColor = Style.tintColor
        window!.backgroundColor = Style.backgroundColor
    }
    
    // MARK: - build main(home) page
    func buildUserInterface(){

        let login = NSUserDefaults.standardUserDefaults().boolForKey("login")

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

