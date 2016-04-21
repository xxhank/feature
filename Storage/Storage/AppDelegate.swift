//
//  AppDelegate.swift
//  Storage
//
//  Created by wangchaojs02 on 16/4/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import SQLite

func SSLogInfo(message: Any, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function) {
    print("<\((fileName as NSString).lastPathComponent):\(lineNumber) \(functionName)>Info: \(message)")
}

func SSLogWarning(message: Any, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function) {
    print("<\((fileName as NSString).lastPathComponent):\(lineNumber) \(functionName)>Warn: \(message)")
}

func SSLogError(message: Any, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function) {
    print("<\((fileName as NSString).lastPathComponent):\(lineNumber) \(functionName)>Error: \(message)")
}

enum DogColor: Int {
    case Black = 0
    case White
    case Green
}

enum DogColorValue: Int {
    case BlackValue
    case WhiteValue
    case GreenValue
}

struct Dog {
    var NO: Int
    var name: String
    var color: DogColor
    var owner: String?
}
struct Person {
    var name: String
    var age: Int
    var addr: String
    var dogs: [Dog]
}

class Soical {
    var name: String
    var addr: String
    var members: [Person]

    init(name: String, addr: String, members: [Person]) {
        self.name = name
        self.addr = addr
        self.members = members
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        let dbPath = SSPath.document.stringByAppendingString("/sample.db")
        SSLogInfo(dbPath)

        let jok = Dog(NO: 12, name: "Jok", color: .Green, owner: nil)

        do {
            let db = try Connection(dbPath)

            let table = Table("Dogs")
            let NO = Expression<Int>("NO")
            let name = Expression<String>("name")
            let color = Expression<Int>("color")
            let owner = Expression<String?>("owner")
            let owner1 = Expression<String?>("owner1")
            let owner2 = Expression<String?>("owner2")
            let owner3 = Expression<String?>("owner3")

            // let result = try db.prepare("PRAGMA user_version")
            // let version = result.row[0] as Int64

            let tableInfo = try db.prepare("PRAGMA table_info(Dogs)")
            if tableInfo.columnCount > 0 {
                var matches: [String: Bool] = [
                    "NO": false,
                    "name": false,
                    "color": false,
                    "owner": false,
                    "owner1": false,
                    "owner2": false,
                    "owner3": false]

                for x in tableInfo {
                    let columnName = x[1] as! String
                    matches[columnName] = true
                }
                // let needAltTable = matches.reduce(0, combine: { (begin, item) -> Int in
                // return begin + (item.1 ? 1 : 0)
                // }) != matches.count
                let missingColumns = matches.filter { !$0.1 }
                for missingColumn in missingColumns {
                    switch missingColumn.0 {
                    case "owner":
                        try db.run(table.addColumn(owner))
                    case "owner1":
                        try db.run(table.addColumn(owner1))
                    case "owner2":
                        try db.run(table.addColumn(owner2))
                    case "owner3":
                        try db.run(table.addColumn(owner3))
                    default: break
                    }
                }
            }

            try db.run(table.create(ifNotExists: true, block: { builder in
                builder.column(NO, primaryKey: .Autoincrement)
                builder.column(name)
                builder.column(color)
                builder.column(owner)
                }))

            try db.run(table.insert(or: .Replace,
                NO <- jok.NO,
                name <- jok.name,
                color <- jok.color.rawValue,
                owner <- jok.owner,
                owner1 <- jok.owner,
                owner2 <- jok.owner,
                owner3 <- jok.owner))
        } catch(let error) {
            SSLogError(error)
        }

        let jokInpsect = Mirror(reflecting: jok)
        for child in jokInpsect.children {
            print("\(child.label!) \(child.value) \(child.value.dynamicType)")
        }

        let tom = Person(name: "tom", age: 33, addr: "American", dogs: [jok])
        let tomInspect = Mirror(reflecting: tom)
        for child in tomInspect.children {
            print("\(child.label!) \(child.value) \(child.value.dynamicType)")
        }
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
