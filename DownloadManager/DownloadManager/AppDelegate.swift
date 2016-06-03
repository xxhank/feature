//
//  AppDelegate.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/5/31.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        SSLogInfo("")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        SSLogInfo("")
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
        SSLogInfo("")
    }
}
