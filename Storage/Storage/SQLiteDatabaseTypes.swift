//
//  SQLiteHelper.swift
//  Storage
//
//  Created by wangchao9 on 16/4/23.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation

enum SQLiteDatabaseType: String {
    case TEMP = "TEMP"
    case TEMPORARY = "TEMPORARY"
}

enum SQLiteDataType {
    case INTEGER
    case TEXT
    case BOOL
    case Double
    case Float
    case Data
    case Image

    var rawValue: String {
        switch self {
        case .INTEGER, .BOOL:
            return "INTEGER"
        case .TEXT:
            return "TEXT"
        case .Double, .Float:
            return "REAL"
        case .Data, .Image:
            return "BLOB"
        }
    }
}

enum SQLiteTableScheme {
    case MAIN
    case TEMP
    case Attached(database: String)

    var rawValue: String {
        switch self {
        case .MAIN:
            return "main"
        case .TEMP:
            return "temp"
        case .Attached(let database):
            return database
        }
    }
}

enum SQLiteConflict: String {
    case NONE = ""
    case ROLLBACK = "ON CONFLICT ROLLBACK"
    case ABORT = "ON CONFLICT ABORT"
    case FAIL = "ON CONFLICT FAIL"
    case IGNORE = "ON CONFLICT IGNORE"
    case REPLACE = "ON CONFLICT REPLACE"
}

enum SQLiteSORT: String {
    case NONE = ""
    case ASC = "ASC"
    case DESC = "DESC"
}

enum SQLiteCapacity {
    case None
    case Value(value: Int)
    case Range(min: Int, max: Int)

    var rawValue: String {
        switch self {
        case None:
            return ""
        case .Value(let size):
            return "(\(size))"
        case .Range(let min, let max):
            return "(\(min), \(max)) "
        }
    }
}

struct SQLiteColumn {
    let name: String
    let type: SQLiteDataType
    let size: SQLiteCapacity
    let constraints: [SQLiteConstraint]

    var rawValue: String {
        let constraintStrings = constraints.map({ return $0.rawValue }).joinWithSeparator(" ")
        return "\(name.ss_quote()) \(type.rawValue)\(size.rawValue) \(constraintStrings)"
    }

    init(name: String, type: SQLiteDataType) {
        self.init(name: name, type: type, size: SQLiteCapacity.None, constraints: [])
    }
    init(name: String, type: SQLiteDataType, size: SQLiteCapacity) {
        self.init(name: name, type: type, size: size, constraints: [])
    }

    init(name: String, type: SQLiteDataType, constraints: [SQLiteConstraint]) {
        self.init(name: name, type: type, size: SQLiteCapacity.None, constraints: constraints)
    }

    init(name: String, type: SQLiteDataType, size: SQLiteCapacity, constraints: [SQLiteConstraint]) {
        self.name = name
        self.type = type
        self.size = size
        self.constraints = constraints
    }
}

enum SQLiteConstraint {
    case PRIMARY_KEY
    case NOT_NULL
    case UNIQUE
    case NOT_NULL_C(confilit: SQLiteConflict)
    case UNIQUE_C(confilit: SQLiteConflict)
    case CHECK(expr: String)
    case DEFAULT(value: AnyObject)
    case COLLATE(name: String)
    case FOREIGN_KEY(clause: String)
    var rawValue: String {
        switch self {
        case .PRIMARY_KEY:
            return "PRIMARY KEY \(SQLiteSORT.ASC.rawValue) \(SQLiteConflict.REPLACE.rawValue) AUTOINCREMENT"
        case .NOT_NULL:
            return "NOT NULL"
        case .UNIQUE:
            return "UNIQUE"
        case .NOT_NULL_C(let confilit):
            return "NOT NULL \(confilit.rawValue)"
        case .UNIQUE_C(let confilit):
            return "UNIQUE \(confilit.rawValue)"
        case .CHECK(let expr):
            return "CHECK \(expr)"
        case .DEFAULT(let value):
            return "DEFAULT \(value)"
        case .COLLATE(let name):
            return "COLLATE \(name)"
        case .FOREIGN_KEY(let clause):
            return "REFERENCES \(clause)"
        }
    }
}