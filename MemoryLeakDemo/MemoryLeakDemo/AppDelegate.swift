//
//  AppDelegate.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/6/26.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import XCGLogger

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        XCGLogger.info("\(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true))")
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
    }

    func applicationDidEnterBackground(application: UIApplication) {
    }

    func applicationWillEnterForeground(application: UIApplication) {
    }

    func applicationDidBecomeActive(application: UIApplication) {
    }

    func applicationWillTerminate(application: UIApplication) {
    }
}