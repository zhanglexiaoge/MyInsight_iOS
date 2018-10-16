//
//  AppDelegate.swift
//  MyInsight_Swift
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMengLong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // 关键字设置
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        debugPrint("程序启动完成")
        
        // 判断应用是否是第一次启动
        self.isRightFirstLaunched()
        
        return true
    }
    
    //MARK: - 判断是否为首次启动
    func isRightFirstLaunched() -> Void {
        /*
         若是第一次加载，进入欢迎页面，若不是直接进入主页面
         */
        let userDefaults: UserDefaults = UserDefaults.standard;
        debugPrint("是不是第一次启动")
        
        if (userDefaults.string(forKey: "LauchAgree") == nil) {
            userDefaults.set(true, forKey: "LauchAgree")
            debugPrint("首次启动 进入欢迎页面")
            
            let welcomeVC: WelcomeVC = WelcomeVC()
            self.window?.rootViewController = welcomeVC
        } else {
            debugPrint("不是首次启动 进入主页面")
            let mainRevealVC: MainRevealVC = MainRevealVC()
            
            self.window?.rootViewController = mainRevealVC
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        debugPrint("WillResignActive 程序将要进入后台")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        debugPrint("DidEnterBackground 程序进入后台")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        debugPrint("WillEnterForeground 程序将要进入前台")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        debugPrint("BecomeActive 程序进入前台")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        debugPrint("WillTerminate 程序退出")
    }
    
}

