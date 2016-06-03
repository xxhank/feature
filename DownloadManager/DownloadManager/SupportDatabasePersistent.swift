//
//  SupportDatabasePersistent.swift
//  DownloadManager
//
//  Created by wangchaojs02 on 16/6/3.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import Foundation

public typealias DatabaseTableColumnDefine = (String, SQLiteDataType, SQLiteCapacity, [SQLiteConstraint])
public protocol SupportDatabasePersistent {
    static func tableName() -> String
    static func databaseName() -> String
    static func columns() -> [DatabaseTableColumnDefine];
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

// MARK: - database operation
extension SupportDatabasePersistent {
    public func db_insert() -> Int64 {
        let tableName = self.dynamicType.tableName()
        let databaseName = self.dynamicType.databaseName()
        let columnDefines = self.dynamicType.columns()
        var names = [String]()
        var values = [Any]()
        for (name, _, _, _) in columnDefines {
            names.append(name)
            if let value = self.valueForColumn(name) {
                values.append(value)
            }
        }

        SQLiteDatabase.alertIfNeed(columnDefines, tableName: tableName, databaseName: databaseName)
        return SQLiteDatabase.insert(columns: names, values: values, in: tableName, database: databaseName)
    }

    public static func db_select() -> [Self] {
        let tableName = Self.tableName()
        let databaseName = Self.databaseName()
        let results = SQLiteDatabase.select(in: tableName, database: databaseName)
        var objects = [Self]()
        for result in results {
            if let object = Self(with: result) {
                objects.append(object)
            }
        }
        return objects
    }

    public static func db_selectFirst() -> Self? {
        let tableName = Self.tableName()
        let databaseName = Self.databaseName()
        let result = SQLiteDatabase.select_first(in: tableName, database: databaseName)
        return Self(with: result)
    }

    public static func db_select(whereSQLStr whereSql: String) -> [Self] {
        let tableName = Self.tableName()
        let databaseName = Self.databaseName()
        let results = SQLiteDatabase.select(in: tableName, condition: whereSql, database: databaseName)
        var objects = [Self]()
        for result in results {
            if let object = Self(with: result) {
                objects.append(object)
            }
        }
        return objects
    }

    public func db_update(columns: [String]) {
        let tableName = self.dynamicType.tableName()
        let databaseName = self.dynamicType.databaseName()
        let WHERE = fiterClause()

        SQLiteDatabase.alertIfNeed(Self.columns(), tableName: tableName, databaseName: databaseName)

        var values = [Any]()
        for column in columns {
            if let value = self.valueForColumn(column) {
                values.append(value)
            }
        }

        SQLiteDatabase.update(
            columns: columns,
            values: values,
            filter: WHERE,
            in: tableName,
            database: databaseName)
    }

    public func db_delete() {
        let tableName = self.dynamicType.tableName()
        let databaseName = self.dynamicType.databaseName()
        let WHERE = fiterClause()
        SQLiteDatabase.delete(rows: WHERE, in: tableName, database: databaseName)
    }

    public static func db_count(type: SupportDatabasePersistent.Type) -> Int64 {
        return SQLiteDatabase.count(in: type.tableName(), database: type.databaseName())
    }

    public static func db_clear() {
        let tableName = Self.tableName()
        let databaseName = Self.databaseName()
        return SQLiteDatabase.clear(tableName, database: databaseName)
    }

    public static func db_drop() {
        let tableName = Self.tableName()
        let databaseName = Self.databaseName()
        return SQLiteDatabase.drop(tableName, database: databaseName)
    }

    func fiterClause() -> String {
        let columnDefines = self.dynamicType.columns()
        var WHERE = ""
        for (name, _, _, constraints) in columnDefines {
            var found = false
            for constraint in constraints {
                switch constraint {
                case .PRIMARY_KEY:
                    found = true
                    break
                default:
                    break
                }
            }
            if found {
                if let value = self.valueForColumn(name) {
                    if let stringValue = value as? String {
                        WHERE = "\(name.columnName)=\((stringValue).columnValue)"
                    } else {
                        WHERE = "\(name.columnName)=\(value)"
                    }
                }
                break
            }
        }
        if WHERE.isEmpty {
            SSLogWarning("cannot crate where form \(self.dynamicType)")
        }
        return WHERE
    }
}