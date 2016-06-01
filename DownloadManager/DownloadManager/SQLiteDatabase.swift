//
//  SSStorge.swift
//  Storage
//
//  Created by wangchao9 on 16/4/23.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import SQLite

public extension Dictionary {
    public func ss_valueForKey<T>(key: Key, defaultValue: T) -> T {
        let valueObject = self[key]
        if let option = valueObject as? T?
        , let value = option {
                return value
        } else if let value = valueObject as? T {
                return value
        } else {
                return defaultValue
        }
    }

    public func ss_valueForKey(key: Key, defaultValue: Int) -> Int {
        if let option = self[key] as? Int64?,
            let value = option {
                return Int(value)
        }
        if let value = self[key] as? Int64 {
            return Int(value)
        }

        if let option = self[key] as? Int?,
            let value = option {
                return Int(value)
        }
        if let value = self[key] as? Int {
            return Int(value)
        }
        return defaultValue
    }
}

extension String {
    public func ss_quote(mark: Character = "\"") -> String {
        let escaped = characters.reduce("") { string, character in
            string + (character == mark ? "\(mark)\(mark)" : "\(character)")
        }
        return "\(mark)\(escaped)\(mark)"
    }

    public var columnValue: String {
        return self.ss_quote("\"")
    }

    public var columnName: String {
        return self.ss_quote("\"")
    }
}

extension Expression {
    func optional() -> Expression<UnderlyingType?> {
        return Expression<UnderlyingType?>(self.template, self.bindings)
    }
}

// MARK: - table
public class SQLiteDatabase {
    class func connect(database: String) -> (Connection?, NSError?) {
        let databasePath = database.hasPrefix("/")
            ? database
            : SSPath.document().stringByAppendingString("/\(database)")
        do {
            let database = try Connection(databasePath)
            return (database, nil)
        } catch(let error) {
            SSLogError("\(error)")
            return (nil, error as NSError)
        }
    }

    class func exists(table: String, database: String) -> Bool {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return false }
        guard let db = databaseResult else { return false }

        do {
            let stmt = try db.prepare("PRAGMA table_info(\(table))")
            let exist = stmt.columnCount > 0
            return exist
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
            return false
        }
    }

    private class func alter(table: String, columns: [SQLiteColumn], database: String) {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }

        do {
            let stmt = try db.prepare("PRAGMA table_info(\(table))")
            let exist = stmt.columnCount > 0
            guard exist else { return }

            var missColumns = [String: SQLiteColumn]()
            for column in columns {
                missColumns[column.name] = column
            }
            for column in stmt {
                if let columnName = column[1] as? String {
                    missColumns.removeValueForKey(columnName)
                }
            }
            // "BEGIN TRANSACTION;"
            // "COMMIT TRANSACTION;"
            var SQLs = [String]()
            for (_, value) in missColumns {
                let SQL = "ALTER TABLE \(table) ADD COLUMN \(value.rawValue);"
                SQLs.append(SQL)
            }

            try db.execute("BEGIN TRANSACTION;\(SQLs.joinWithSeparator("\n"));COMMIT TRANSACTION;")
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
        }
    }

    private class func create(tableName: String, columns: [SQLiteColumn], database: String, onlyCreateIfNotExist: Bool = true) {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }

        do {
            let databaseType = ""
            let ifNotExist = onlyCreateIfNotExist ? "IF NOT EXISTS" : ""
            let schemeName = ""

            let columnsText = columns.reduce("", combine: { (total, current) -> String in
                if total == "" {
                    return "\(current.rawValue)"
                } else {
                    return total + ", \(current.rawValue)"
                }
            })
            let SQL = "CREATE \(databaseType) TABLE \(ifNotExist) \(schemeName) \(tableName) ( \(columnsText) )"
            try db.execute(SQL)
        } catch(let error) {
            SSLogError("\(error)")
        }
    }
    class func clear(table: String, database: String) {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }
        do {
            let SQL = "DELETE FROM \(table)"
            try db.run(SQL)
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
        }
    }
    class func drop(tableName: String, database: String) {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }
        do {
            let SQL = "DROP TABLE IF EXISTS \(tableName)"
            try db.run(SQL)
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
        }
    }
    class func count(in tableName: String, rows condition: String = "", database: String) -> Int64 {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return 0 }
        guard let db = databaseResult else { return 0 }
        do {
            let WHRER = condition.isEmpty ? "" : "WHERE \(condition)"
            let SQL = "SELECT count(*) FROM \(tableName) \(WHRER)"
            let stmt = try db.prepare(SQL)
            let count = stmt.scalar() as? Int64
            return count ?? 0
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
        }
        return 0
    }
}

// MARK: - row
extension SQLiteDatabase {
    public class func select(in tableName: String, condition: String = "", database: String) -> [[String: Any]] {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return [] }
        guard let db = databaseResult else { return [] }
        var objects = [[String: Any]]()

        do {
            let WHRER = condition.isEmpty ? "" : "WHERE \(condition)"
            let SQL = "SELECT * FROM \(tableName) \(WHRER)"
            let stmt = try db.run(SQL)

            objects = SQLiteDatabase.presents(from: stmt)
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
        }

        return objects
    }

    class func select_first(in tableName: String, condition: String = "", database: String) -> [String: Any] {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return [:] }
        guard let db = databaseResult else { return [:] }
        var objects = [[String: Any]]()

        do {
            let WHRER = condition.isEmpty ? "" : "WHERE \(condition) "
            let LIMIT = "LIMIT 1 OFFSET 0"
            let SQL = "SELECT * FROM \(tableName) \(WHRER) \(LIMIT)"
            let stmt = try db.run(SQL)
            objects = SQLiteDatabase.presents(from: stmt)
        } catch(let error) {
            if let SQLError = error as? SQLite.Result {
                switch SQLError {
                case .Error(let message, _, _):
                    if !message.hasPrefix("no such table") {
                        SSLogError("\(error)")
                    }
                }
            } else {
                SSLogError("\(error)")
            }
        }

        return objects.first ?? [:]
    }

    class func insert(columns columnNames: [String], values: [Any], in tableName: String, database: String) -> Int64 {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return -1 }
        guard let db = databaseResult else { return -1 }

        let columnNamesText = columnNames.reduce("") { (total, _tail) -> String in
            if total == "" {
                return _tail.columnName
            } else {
                return total + ", \(_tail.columnName)"
            }
        }

        let valuesMask = columnNames.reduce("", combine: { (total, _tail) -> String in
            if total == "" {
                return "?"
            } else {
                return total + ", ?"
            }
        })
        let SQL = "INSERT INTO \(tableName) (\(columnNamesText)) VALUES (\(valuesMask))"
        do {
            let stmt = try db.prepare(SQL)
            let bindings = values.map({ (item) -> Binding? in
                if item is Binding {
                    return item as? Binding
                } else {
                    SSLogError("\(item) cannot convert to Binding")
                    return nil
                }
            })

            try stmt.run(bindings)
            return db.lastInsertRowid ?? -1
        } catch(let error) {
            SSLogError("\(error) \(SQL)")
        }
        return -1
    }

    class func update(columns columnNames: [String], values: [Any], filter: String, in tableName: String, database: String) {

        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }
        let updatesText = prepareForUpdate(columns: columnNames, values: values)
        let SQL = "UPDATE \(tableName) SET \(updatesText) WHERE \(filter)"
        do {
            // SSLogInfo(SQL)
            try db.run(SQL)
        } catch(let error) {
            SSLogError("\(error)")
        }
    }

    public class func update(rows condition: String, with values: [String: Any], in table: String, database: String) {
        SQLiteDatabase.update(
            columns: Array(values.keys),
            values: Array(values.values),
            filter: condition,
            in: table,
            database: database)
    }

    public class func delete(rows condition: String, in table: NSString, database: String) {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }
        do {
            let SQL = "DELETE FROM \(table) WHERE \(condition)"
            try db.run(SQL)
        } catch(let error) {
            SSLogError("\(error)")
        }
    }
    // MARK: help
    class func prepareForInsert(columns columnNames: [String], values: [Any]) -> (String, String) {
        let columnNamesText = columnNames.joinWithSeparator(", ")
        let valuesText = values.reduce("", combine: { (total, current) -> String in
            var value: Any = current
            if value is String {
                value = "\"\(value)\""
            }
            if total == "" {
                return "\(value)"
            } else {
                return total + ", \(value)"
            }
        })

        return (columnNamesText, valuesText)
    }

    class func prepareForUpdate(columns columnNames: [String], values: [Any]) -> String {
        var results = [String]()
        for (index, name) in columnNames.enumerate() {
            var value: Any = values[index]
            if value is String {
                value = "\"\(value)\""
            }
            results.append("\(name)=\(value)")
        }

        let resultsText = results.reduce("", combine: { (total, current) -> String in
            if total == "" {
                return "\(current)"
            } else {
                return total + ", \(current)"
            }
        })

        return resultsText
    }

    class func presents(from statement: Statement) -> [[String: Any]] {
        var objects = [[String: Any]]()
        for row in statement {
            var mapper = [String: Any]()
            for (index, name) in statement.columnNames.enumerate() {
                let value = row[index]
                if let stringValue = value as? String {
                    mapper[name] = stringValue
                } else if let dobuleValue = value as? Double {
                    mapper[name] = dobuleValue
                } else if let int64Value = value as? Int64 {
                    mapper[name] = int64Value
                } else if let intValue = value as? Int {
                    mapper[name] = intValue
                } else if let blobValue = value as? Blob {
                    mapper[name] = blobValue
                } else if let boolValue = value as? Bool {
                    mapper[name] = boolValue
                } else {
                    if nil != value {
                        SSLogError("unspport type:\(value!) for \(name)")
                    }
                }
            }
            objects.append(mapper)
        }
        return objects
    }
}

// MARK: -
enum TableStatus: Int {
    case Alerted = 1
}
extension SQLiteDatabase: Database {
    public class func insert(object: SupportDatabasePersistent) -> Int64 {
        let tableName = object.dynamicType.tableName()
        let databaseName = object.dynamicType.databaseName()
        var columns = [SQLiteColumn]()
        let columnDefines = object.dynamicType.columns()
        var names = [String]()
        var values = [Any]()
        for (name, type, size, constraints) in columnDefines {
            columns.append(SQLiteColumn(name: name, type: type, size: size, constraints: constraints))
            names.append(name)
            if let value = object.valueForColumn(name) {
                values.append(value)
            }
        }
        if SQLiteDatabase.exists(tableName, database: databaseName) {
            if SQLiteDatabase.needAlert(tableName) {
                SQLiteDatabase.alter(tableName, columns: columns, database: databaseName)
            }
        } else {
            SQLiteDatabase.create(tableName, columns: columns, database: databaseName)
        }
        return SQLiteDatabase.insert(columns: names, values: values, in: tableName, database: databaseName)
    }
    public class func select_first<T: SupportDatabasePersistent>() -> T? {
        let tableName = T.tableName()
        let databaseName = T.databaseName()
        let result = SQLiteDatabase.select_first(in: tableName, database: databaseName)
        return T(with: result)
    }
    public class func select<T: SupportDatabasePersistent>() -> [T] {
        let tableName = T.tableName()
        let databaseName = T.databaseName()
        let results = SQLiteDatabase.select(in: tableName, database: databaseName)
        var objects = [T]()
        for result in results {
            if let object = T(with: result) {
                objects.append(object)
            }
        }
        return objects
    }

    public class func select<T: SupportDatabasePersistent>(whereSQLStr whereSql: String) -> [T] {
        let tableName = T.tableName()
        let databaseName = T.databaseName()
        let results = SQLiteDatabase.select(in: tableName, condition: whereSql, database: databaseName)
        var objects = [T]()
        for result in results {
            if let object = T(with: result) {
                objects.append(object)
            }
        }
        return objects
    }

    public class func update(object: SupportDatabasePersistent, with values: [String: Any]) {
        let tableName = object.dynamicType.tableName()
        let databaseName = object.dynamicType.databaseName()
        let WHERE = SQLiteDatabase.fiterClause(object)

        SQLiteDatabase.update(
            columns: Array(values.keys),
            values: Array(values.values),
            filter: WHERE,
            in: tableName,
            database: databaseName)
    }

    public class func delete(object: SupportDatabasePersistent) {
        let tableName = object.dynamicType.tableName()
        let databaseName = object.dynamicType.databaseName()
        let WHERE = SQLiteDatabase.fiterClause(object)
        SQLiteDatabase.delete(rows: WHERE, in: tableName, database: databaseName)
    }

    public class func count(type: SupportDatabasePersistent.Type) -> Int64 {
        return SQLiteDatabase.count(in: type.tableName(), database: type.databaseName())
    }

    public class func clear(type: SupportDatabasePersistent.Type) {
        let tableName = type.tableName()
        let databaseName = type.databaseName()
        return SQLiteDatabase.clear(tableName, database: databaseName)
    }

    public class func drop(type: SupportDatabasePersistent.Type) {
        let tableName = type.tableName()
        let databaseName = type.databaseName()
        return SQLiteDatabase.drop(tableName, database: databaseName)
    }
    // MARK: helper
    class func fiterClause(object: SupportDatabasePersistent) -> String {
        let columnDefines = object.dynamicType.columns()
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
                if let value = object.valueForColumn(name) {
                    if let stringValue = value as? String {
                        WHERE = "\(name)=\((stringValue).columnValue)"
                    } else {
                        WHERE = "\(name)=\(value)"
                    }
                }
                break
            }
        }
        if WHERE.isEmpty {
            SSLogWarning("cannot crate where form \(object.dynamicType)")
        }
        return WHERE
    }

    static var TableStatuses = [String: TableStatus]()
    class func needAlert(tableName: String) -> Bool {
        if (TableStatuses[tableName] == nil) {
            TableStatuses[tableName] = .Alerted
            return true
        } else {
            return false
        }
    }
}
