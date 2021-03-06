//
//  AppDelegate.swift
//  Career Endorsement Tracker
//
//  Created by Sameera Roussi on 8/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit
//import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // MARK: - OneSignal
        
//        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
//        
//        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
//        OneSignal.initWithLaunchOptions(launchOptions,
//                                        appId: "3d784906-6ece-4290-8f06-fc8e4cc60030",
//                                        handleNotificationAction: nil,
//                                        settings: onesignalInitSettings)
//        
//        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
//        
//        // Recommend moving the below line to prompt for push after informing the user about
//        //   how your app will use them.
//        OneSignal.promptForPushNotifications(userResponse: { accepted in
//            print("User accepted notifications: \(accepted)")
//        })
        
        // MARK: - End OneSignal
        
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            // user is already logged in, present chat VC, but from MainVC, in order to unwind back to mainVC when user log out.
            if UserDefaults.standard.bool(forKey: "isAdmin") {
                print("user is already logged in")
                let storyboard = UIStoryboard(name: "Coaches", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "CoachTabBarController")
                window?.rootViewController = vc
            } else {
                print("user is already logged in")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController")
                window?.rootViewController = vc
            }
        } else {
            // user is not logged in
            print("user is not logged in")
            let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
            print("Storyboard")
            let vc = storyboard.instantiateViewController(withIdentifier: "WelcomeNavigationController")
            window?.rootViewController = vc
        }
        
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        
        UserDefaults.standard.set(token, forKey: UserDefaultsKeys.deviceToken)
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

