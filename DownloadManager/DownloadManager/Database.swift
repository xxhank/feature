//
//  Database.swift
//  Pods
//
//  Created by wangchao9 on 16/4/23.
//
//

import Foundation

public protocol SupportDatabasePersistent {
    static func tableName() -> String
    static func databaseName() -> String
    static func columns() -> [(String, SQLiteDataType, SQLiteCapacity, [SQLiteConstraint])];
    init?(with dict: [String: Any])
    func valueForColumn(column: String) -> Any?
}

extension SupportDatabasePersistent {
    static func tableName() -> String {
        return "\(self)"
    }
    static func databaseName() -> String {
        return "SARRS.db"
    }
}

public protocol Database {
    static func insert(object: SupportDatabasePersistent) -> Int64
    static func select<T: SupportDatabasePersistent>() -> [T]
    static func select_first<T: SupportDatabasePersistent>() -> T?
    static func update(object: SupportDatabasePersistent, with values: [String: Any])
    static func delete(object: SupportDatabasePersistent)
    static func count(type: SupportDatabasePersistent.Type) -> Int64
    static func clear(type: SupportDatabasePersistent.Type)
    static func drop(type: SupportDatabasePersistent.Type)
}