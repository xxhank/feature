//
//  ViewController.swift
//  Storage
//
//  Created by wangchaojs02 on 16/4/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import SQLite

// MARK: -
extension Dog: StorageConvertiable {
    static func tableName() -> String {
        return "\(self)"
    }
    static func databaseName() -> String {
        return "social.db"
    }

    static func columns() -> [(String, SQLiteDataType, SQLiteCapacity, [SQLiteConstraint])] {
        return [
            ("NO", .INTEGER, .None, [SQLiteConstraint.PRIMARY_KEY]),
            ("name", .TEXT, .Range(min: 3, max: 10), []),
            ("color", .INTEGER, .None, []),
            ("owner", .TEXT, .None, [])
        ]
    }

    init?(with present: [String: Any]) {
        self.NO = present.ss_valueForKey("NO", defaultValue: -1)
        self.name = present.ss_valueForKey("name", defaultValue: "")
        self.color = DogColor(rawValue: present.ss_valueForKey("color", defaultValue: 0)) ?? .Black
        self.owner = present.ss_valueForKey("owner", defaultValue: nil)
    }

    func valueForColumn(column: String) -> Any? {
        switch column {
        case "NO":
            return self.NO
        case "name":
            return self.name
        case "color":
            return self.color.rawValue
        case "owner":
            return self.owner
        default:
            SSLogError("not exist property")
            return nil
        }
    }
}

extension Person: StorageConvertiable {
    static func tableName() -> String {
        return "\(self)"
    }
    static func databaseName() -> String {
        return "social.db"
    }

    static func columns() -> [(String, SQLiteDataType, SQLiteCapacity, [SQLiteConstraint])] {
        return [
            ("NO", .INTEGER, .None, [SQLiteConstraint.PRIMARY_KEY]),
            ("name", .TEXT, .Range(min: 3, max: 10), []),
            ("age", .INTEGER, .None, []),
            ("addr", .TEXT, .None, [])
        ]
    }

    init?(with present: [String: Any]) {
        self.NO = present.ss_valueForKey("NO", defaultValue: -1)
        self.name = present.ss_valueForKey("name", defaultValue: "")
        self.age = present.ss_valueForKey("age", defaultValue: 0)
        self.addr = present.ss_valueForKey("addr", defaultValue: "")
        self.dogs = []
    }

    func valueForColumn(column: String) -> Any? {
        switch column {
        case "NO":
            return self.NO
        case "name":
            return self.name
        case "age":
            return self.age
        case "addr":
            return self.addr
        default:
            SSLogError("not exist property")
            return nil
        }
    }
}
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        SSLogInfo(SSPath.document)
        let count = SQLiteDatabase.count(Dog)
        SSLogInfo(count)
        // var dog = Dog(NO: Int(count), name: "xxx", color: .Black, owner: "wangchao")
        // SSStorge.insert(dog)
        // SSLogInfo(SSStorge.count(Dog))
        // SSStorge.update(dog, with: ["color": DogColor.Green.rawValue])
        SSLogInfo(SQLiteDatabase.select() as [Dog])
        // SSStorge.delete(dog)
        // SSLogInfo(SSStorge.count(Dog))

        SSLogInfo(SQLiteDatabase.select() as [Person])
        // let wangchao = Person(NO: Int(count), name: "wangchao", age: 33, addr: "beijing", dogs: [dog])
        // SSStorge.insert(wangchao)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
