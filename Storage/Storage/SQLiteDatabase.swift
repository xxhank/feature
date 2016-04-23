//
//  SSStorge.swift
//  Storage
//
//  Created by wangchao9 on 16/4/23.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation
import SQLite

protocol StorageConvertiable {
    static func tableName() -> String
    static func databaseName() -> String
    static func columns() -> [(String, SQLiteDataType, SQLiteCapacity, [SQLiteConstraint])];
    init?(with dict: [String: Any])
    func valueForColumn(column: String) -> Any?
}

extension Dictionary {
    func ss_valueForKey<T>(key: Key, defaultValue: T) -> T {
        return self[key] as? T ?? defaultValue
    }

    func ss_valueForKey(key: Key, defaultValue: Int) -> Int {
        if let value = self[key] as? Int64 {
            return Int(value)
        }
        return self[key] as? Int ?? defaultValue
    }
}

extension String {
    func ss_quote(mark: Character = "\"") -> String {
        let escaped = characters.reduce("") { string, character in
            string + (character == mark ? "\(mark)\(mark)" : "\(character)")
        }
        return "\(mark)\(escaped)\(mark)"
    }
}

extension Expression {
    func optional() -> Expression<UnderlyingType?> {
        return Expression<UnderlyingType?>(self.template, self.bindings)
    }
}

// MARK: - table
public class SQLiteDatabase {
    private class func connect(database: String) -> (Connection?, NSError?) {
        let databasePath = SSPath.document.stringByAppendingString("/\(database)")
        do {
            let database = try Connection(databasePath)
            return (database, nil)
        } catch(let error) {
            SSLogError(error)
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
            SSLogError(error)
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
            SSLogError(error)
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
            SSLogError(error)
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
            SSLogError(error)
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
            SSLogError(error)
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
            SSLogError(error)
        }
        return 0
    }
}

// MARK: - row

extension SQLiteDatabase {
    class func select(in tableName: String, condition: String = "", database: String) -> [[String: Any]] {
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
            SSLogError(error)
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
            SSLogError(error)
        }

        return objects.first ?? [:]
    }

    class func insert(columns columnNames: [String], values: [Any], in tableName: String, database: String) -> Int64 {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return -1 }
        guard let db = databaseResult else { return -1 }
        do {
            #if false
                let (columnNamesText, valuesText) = prepareForInsert(columns: columnNames, values: values)
                let SQL = "INSERT INTO \(tableName) (\(columnNamesText)) VALUES (\(valuesText))"

                SSLogInfo(SQL)
                let stmt = try db.run(SQL)
                SSLogInfo(stmt)
            #else
                let columnNamesText = columnNames.joinWithSeparator(", ")
                let valuesMask = columnNames.reduce("", combine: { (total, _tail) -> String in
                    if total == "" {
                        return "?"
                    } else {
                        return total + ", ?"
                    }
                })
                let SQL = "INSERT INTO \(tableName) (\(columnNamesText)) VALUES (\(valuesMask))"
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
            #endif
        } catch(let error) {
            SSLogError(error)
        }
        return -1
    }

    class func update(columns columnNames: [String], values: [Any], filter: String, in tableName: String, database: String) {

        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }
        do {

            let updatesText = prepareForUpdate(columns: columnNames, values: values)
            let SQL = "UPDATE \(tableName) SET \(updatesText) WHERE \(filter)"
            SSLogInfo(SQL)
            try db.run(SQL)
        } catch(let error) {
            SSLogError(error)
        }
    }

    class func delete(rows condition: String, in table: NSString, database: String) {
        let (databaseResult, errorResult) = SQLiteDatabase.connect(database)
        guard errorResult == nil else { return }
        guard let db = databaseResult else { return }
        do {
            let SQL = "DELETE FROM \(table) WHERE \(condition)"
            try db.run(SQL)
        } catch(let error) {
            SSLogError(error)
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
            results.append("\(name) = \(value)")
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
                if let value = row[index] as? String {
                    mapper[name] = value
                } else if let value = row[index] as? Double {
                    mapper[name] = value
                } else if let value = row[index] as? Int64 {
                    mapper[name] = value
                } else if let value = row[index] as? Int {
                    mapper[name] = value
                } else if let value = row[index] as? Blob {
                    mapper[name] = value
                } else if let value = row[index] as? Bool {
                    mapper[name] = value
                } else {
                    SSLogError("unspport type:\(row[index])")
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
extension SQLiteDatabase {
    static var TableStatuses = [String: TableStatus]()
    class func needAlert(tableName: String) -> Bool {
        if (TableStatuses[tableName] == nil) {
            TableStatuses[tableName] = .Alerted
            return true
        } else {
            return false
        }
    }

    class func insert(object: StorageConvertiable) {
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
        SQLiteDatabase.insert(columns: names, values: values, in: tableName, database: databaseName)
    }
    class func select<T: StorageConvertiable>() -> [T] {
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
    class func update(object: StorageConvertiable, with values: [String: Any]) {
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
    class func delete(object: StorageConvertiable) {
        let tableName = object.dynamicType.tableName()
        let databaseName = object.dynamicType.databaseName()
        let WHERE = SQLiteDatabase.fiterClause(object)
        SQLiteDatabase.delete(rows: WHERE, in: tableName, database: databaseName)
    }

    class func count(type: StorageConvertiable.Type) -> Int64 {
        return SQLiteDatabase.count(in: type.tableName(), database: type.databaseName())
    }

    class func fiterClause(object: StorageConvertiable) -> String {
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
                    WHERE = "\(name) = \(value)"
                }
                break
            }
        }
        return WHERE
    }
}
