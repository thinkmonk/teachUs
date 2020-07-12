//
//  AppDelegate.swift
//  TeachUs
//
//  Created by APPLE on 13/10/17.
//  Copyright © 2017 TeachUs. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,MessagingDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        let path = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        #if DEBUG
            print("DB PATH\(path)")
        #endif
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: .notificationLoginSuccess, object: nil)
        UNUserNotificationCenter.current().delegate = self
        if #available(iOS 10, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
            application.registerForRemoteNotifications()
        }
            // iOS 9 support
        else if #available(iOS 9, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 8 support
        else if #available(iOS 8, *) {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
            // iOS 7 support
        else {
            application.registerForRemoteNotifications(matching: [.badge, .sound, .alert])
        }
        
//        UserManager.sharedUserManager.initLoggedInUser()
//        if(UserManager.sharedUserManager.appUserDetails != nil){
//            loginSuccess()
//        }
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        GlobalFunction.setFCMToken(fcmToken)
        let dataDict:[String: String] = ["token": fcmToken]
        UserDefaults.standard.set(NSNumber(value: 0), forKey: "INSTALLED")//reset the flag when new token is received so that it can be synced to server.
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Convert token to string
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        GlobalFunction.setDeviceToken(deviceTokenString)
        // Print it to console
        print("APNs device token: \(deviceTokenString)")
        
        // Persist it in your backend in case it's new
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Print the error to console (you should alert the user that registration failed)
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch application.applicationState{
        case .inactive:
            if let mfmenuVc = self.window?.topViewController() as? MFSideMenuContainerViewController,
            let centerVc = mfmenuVc.centerViewController as? UINavigationController,
            let homeVc = centerVc.topViewController as? HomeViewController{
            homeVc.bellNotificationAction()
        }else{
            UserDefaults.standard.set(true, forKey: Constants.UserDefaults.notifiocationReceived)
            }
        default:
            break
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        // Print notification payload data
        print("Push notification received: \(data)")
        
        switch application.applicationState {
        case .active:
            //app is currently active, can update badges count here
            NotificationCenter.default.post(name: .performNotificationNavigation, object: nil)
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            if let mfmenuVc = self.window?.topViewController() as? MFSideMenuContainerViewController,
                let centerVc = mfmenuVc.centerViewController as? UINavigationController,
                let homeVc = centerVc.topViewController as? HomeViewController{
                homeVc.bellNotificationAction()
            }else{
                UserDefaults.standard.set(true, forKey: Constants.UserDefaults.notifiocationReceived)
            }
            break
        case .background:
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
           if let mfmenuVc = self.window?.topViewController() as? MFSideMenuContainerViewController,
               let centerVc = mfmenuVc.centerViewController as? UINavigationController,
               let homeVc = centerVc.topViewController as? HomeViewController{
               homeVc.bellNotificationAction()
           }else{
                UserDefaults.standard.set(true, forKey: Constants.UserDefaults.notifiocationReceived)
            }
            break
        default:
            break
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        ReachabilityManager.shared.stopMonitoring()

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        ReachabilityManager.shared.stopMonitoring()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ReachabilityManager.shared.startMonitoring()

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TeachUs")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - Login success notification
    
    @objc func loginSuccess(){
        UserManager.sharedUserManager.initLoggedInUser()
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let mfslidemenuContainer = mainStoryBoard.instantiateViewController(withIdentifier: "MFSideMenuContainerViewController") as!MFSideMenuContainerViewController
        self.window?.rootViewController = nil
        self.window?.rootViewController = mfslidemenuContainer
        
        let centerNavigationController = mainStoryBoard.instantiateViewController(withIdentifier: "navigationController") as! UINavigationController
        
        let leftMenuController = mainStoryBoard.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let homeVc:HomeViewController = centerNavigationController.topViewController as! HomeViewController
        leftMenuController.delegate = homeVc as LeftMenuDeleagte
        mfslidemenuContainer.leftMenuViewController = leftMenuController
        mfslidemenuContainer.centerViewController  = centerNavigationController
        mfslidemenuContainer.panMode = MFSideMenuPanModeNone
        UserManager.sharedUserManager.isUserInOfflineMode = false
    }
}

extension AppDelegate:UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([.alert, .badge, .sound])
    }
}
