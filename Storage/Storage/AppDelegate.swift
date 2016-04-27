//
//  AppDelegate.swift
//  Storage
//
//  Created by wangchaojs02 on 16/4/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import SQLite

class Storage2 {
    class func connect_table(table tableName: String, fields: [Expressible], primaryKey: String, database: String) -> (Connection?, Table?, NSError?) {
        let databasePath = SSPath.document.stringByAppendingString("/\(database)")
        do {
            SSLogInfo(databasePath)
            SSLogInfo(tableName)
            let database = try Connection(databasePath)
            let table = Table(tableName)
            if fields.count == 0 {
                return (database, table, nil)
            }

            let tableInfo = try database.prepare("PRAGMA table_info(\(tableName))")
            try database.run(table.create(ifNotExists: true, block: { builder in
                for field in fields {
                    let isPrimaryKey = field.expression.template == primaryKey.ss_quote()
                    if let expression = field as? Expression<Int> {
                        builder.column(expression, primaryKey: isPrimaryKey)
                    } else if let expression = field as? Expression<Int64> {
                        builder.column(expression, primaryKey: isPrimaryKey)
                    } else if let expression = field as? Expression<String> {
                        builder.column(expression, primaryKey: isPrimaryKey)
                    } else if let expression = field as? Expression<String?> {
                        builder.column(expression)
                    } else if let expression = field as? Expression<Double> {
                        builder.column(expression)
                    } else {
                        SSLogError("unexcept type : \(field)")
                    }
                } }))

            var missColumns = [String: Expressible]()
            for field in fields {
                missColumns[field.expression.template] = field
            }
            for column in tableInfo {
                if let columnName = column[1] as? String {
                    missColumns.removeValueForKey(columnName.ss_quote())
                }
            }

            for (_, value) in missColumns {
                if let expression = value as? Expression<Int> {
                    try database.run(table.addColumn(expression.optional()))
                } else if let expression = value as? Expression<Int64> {
                    try database.run(table.addColumn(expression.optional()))
                } else if let expression = value as? Expression<String> {
                    try database.run(table.addColumn(expression.optional()))
                } else if let expression = value as? Expression<String?> {
                    try database.run(table.addColumn(expression))
                } else if let expression = value as? Expression<Double> {
                    try database.run(table.addColumn(expression.optional()))
                } else {
                    SSLogError("unexcept type : \(value)")
                }
            }

            return (database, table, nil)
        } catch(let error) {
            return (nil, nil, error as NSError)
        }
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
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
    }
}
