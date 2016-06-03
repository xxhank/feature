//
//  Fluff.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/6/3.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import Foundation

func processNames(names: [String]) -> String {
    return names.map({ return $0.columnName }).joinWithSeparator(", ")
}

func processValues(values: [Any]) -> String {
    var results = [String]()
    for value in values {
        if let stringValue = value as? String {
            results.append ("\(stringValue.columnValue)")
        } else {
            results.append("\(value)")
        }
    }

    return results.joinWithSeparator(", ")
}

func processNameAndValues(values: [String: Any]) -> String {
    var results = [String]()
    for (key, value) in values {
        if let stringValue = value as? String {
            results.append ("\(key.columnName) = \(stringValue.columnValue)")
        } else {
            results.append("\(key.columnName) = \(value)")
        }
    }

    return results.joinWithSeparator(", ")
}

public enum FluffOrder: String {
    case ASC = "ASC"
    case DESC = "DESC"
}

public enum FluffType {
    case NULL
    case INTEGER// 1,2,3,4,8
    case REAL
    case TEXT
    case BLOB
}

public enum FluffJOIN {
    /**
     交集查询

     SELECT a1, a2, b1, b2
     FROM A
     INNER JOIN B on B.f = A.f;

     result A&B
     */
    case INNER
    /*
     左连查询

     SELECT a1, a2, b1, b2
     FROM A
     LEFT JOIN B on B.f = A.f;

     result A
     */
    case LEFT
    case SELF
}
/**
 通配符

 - ANY: 任意多个字符
 - ONE: 单个字符
 */
public enum FluffLikeWildcard: String {
    case ANY = "%"
    case ONE = "_"
}

/**
 通配符

 - ANY: 任意多个字符
 - ONE: 单个字符
 */
public enum FluffGLOBWildcard: String {
    case ANY = "*"
    case ONE = "?"
}

public enum FluffCondition: CustomStringConvertible {
    case Equal(value: Any)
    case NotEqual(value: Any)
    case Less(value: Any)
    case Greater(value: Any)
    case LessOrEqual(value: Any)
    case GreaterOrEqual(value: Any)
    case AND
    case OR
    case NOT
    case ALL
    case ANY
    case BETWEEN
    case EXISTS
    case IN_Values(values: [Any])
    case IN_Query(query: String)
    case LIKE(pattern: String, escape: FluffLikeWildcard?)
    case GLOB(regex: String)

    public var description: String {
        switch self {
        case .Equal(let value): return "= \(value)"
        case .NotEqual(let value): return "!= \(value)"
        case .Less(let value): return "< \(value)"
        case .Greater(let value): return "> \(value)"
        case .LessOrEqual(let value): return "<= \(value)" case .GreaterOrEqual(let value): return ">= \(value)"
        case .AND:
            break
        case .OR:
            break
        case .NOT:
            break
        case .ALL:
            break
        case .ANY:
            break
        case .BETWEEN:
            break
        case .EXISTS:
            break
        case .IN_Values(let values):
            return "IN (\(processValues(values)))"
        case .IN_Query(let query):
            return "IN (\(query))"
        case .LIKE(let pattern, let escape):
            if let escape_ = escape {
                return "LIKE \(pattern.columnValue) ESCAPE \"\(escape_.rawValue)\""
            } else {
                return "LIKE \(pattern.columnValue)"
            }
        case .GLOB(let regex):
            return "GLOB \(regex.columnValue)"
        }

        return ""
    }
}
public enum FluffColumn: CustomStringConvertible {
    case Column(name: String, order: FluffOrder)
    case Column_ASC(name: String)
    case Column_DESC(name: String)

    public var description: String {
        switch self {
        case .Column(let name, let order):
            return "\(name.columnName) \(order)"
        case .Column_ASC(let name):
            return "\(name.columnName) \(FluffOrder.ASC)"
        case .Column_DESC(let name):
            return "\(name.columnName) \(FluffOrder.DESC)"
        }
    }
}

public enum FluffForeignKeyAction: String {
    case SET_NULL = "SET NULL"
    case SET_DEFAULT = "SET DEFAULT"
    case RESTRICT = "RESTRICT"
    case CASCADE = "CASCADE"
    case NO_ACTION = "NO ACTION"
}

public enum FluffForeignKeyEvent: CustomStringConvertible {
    case UPDATE(action: FluffForeignKeyAction)
    case DELETE(action: FluffForeignKeyAction)
    public var description: String {
        switch self {
        case .UPDATE(let action):
            return "ON UPDATE \(action)"
        case .DELETE(let action):
            return "ON DELETE \(action)"
        }
    }
}

public enum FluffConstraints: CustomStringConvertible {
    case PRIMARY_KEY
    case UNIQUE
    case NOT_NULL
    case CHECK
    case FOREIGN_KEY(cloumn: String, reference: (table: String, column: String), events: [FluffForeignKeyEvent]?)
    case TABLE_PRIMARY_KEY(columns: [String])
    case TABLE_FOREIGN_KEY

    public var description: String {
        switch self {
        case .PRIMARY_KEY: return "PRIMARY KEY"
        case .UNIQUE: return "UNIQUE"
        case .NOT_NULL: return "NOT NULL"
        case .CHECK: return "CHECK"
        case .FOREIGN_KEY(let cloumn, let reference, let events):
            if let events_ = events {
                return "FOREIGN KEY (\(cloumn.columnName)) REFERENCES \(reference.0.columnName)(\(reference.1.columnName))"
            } else {
                return "FOREIGN KEY (\(cloumn.columnName)) REFERENCES \(reference.0.columnName)(\(reference.1.columnName))"
            }

        case .TABLE_PRIMARY_KEY(let columns): break
        case .TABLE_FOREIGN_KEY: break
        }

        return ""
    }
}
public enum FluffClause: CustomStringConvertible {
    case CREATE_TABLE(createIfNotExists: Bool, table: String,
        constraints: [(column: String, type: FluffType, constraints: [FluffConstraints])], constraints: [FluffConstraints]?)

    case SELECT(distinct: Bool, columns: [String])
    case INSERT(table: String, columns: [String], values: [Any])
    case INSERT_ROWS(table: String, columns: [String], values: [[Any]])
    case INSERT_QUERY(table: String, query: String)
    case UPDATE(table: String, values: [String: Any], WHERE: String?, ORDER: String?, LIMIT: String?)
    case DELETE(table: String, WHERE: String?, ORDER: String?, LIMIT: String?)

    case FROM(tables: [String])
    case JOIN
    case WHERE(column: String, condition: FluffCondition)
    case ORDER(columns: [FluffColumn])
    case LIMIT(count: Int, offset: Int)
    case GROUP(columns: [String])
    case HAVING(column: String, condition: FluffCondition)

    public var description: String {
        switch self {
        case .SELECT(let distinct, let columns):
            let columnsText = processNames(columns)
            if distinct {
                return "SELECT DISTINCT \(columnsText)"
            } else {
                return "SELECT \(columnsText)"
            }
        case .INSERT(let table, let columns, let values):
            return "INSERT INTO \(table.columnName) (\(processNames(columns))) VALUES (\(processValues(values)))"
        case .INSERT_ROWS(let table, let columns, let values):
            let rowValues = values.map({ return "(\(processValues($0)))" })
            return "INSERT INTO \(table.columnName) (\(processNames(columns))) VALUES \(rowValues.joinWithSeparator(", "))"

        case .INSERT_QUERY(let table, let query):
            return "INSERT INTO \(table.columnName) \(query)"
        case .UPDATE(let table, let values, let WHERE, let ORDER, let LIMIT):
            let WHERE_ = WHERE == nil ? "" : " \(WHERE!)"
            let ORDER_ = ORDER == nil ? "" : " \(ORDER!)"
            let LIMIT_ = LIMIT == nil ? "" : " \(LIMIT!)"
            return "UPDATE \(table.columnName) SET \(processNameAndValues(values))\(WHERE_)\(ORDER_)\(LIMIT_)"
        case .DELETE(let table, let WHERE, let ORDER, let LIMIT):
            let WHERE_ = WHERE == nil ? "" : " \(WHERE!)"
            let ORDER_ = ORDER == nil ? "" : " \(ORDER!)"
            let LIMIT_ = LIMIT == nil ? "" : " \(LIMIT!)"
            return "DELETE FROM \(table.columnName)\(WHERE_)\(ORDER_)\(LIMIT_)"

        case .FROM(let tables):
            return "FROM \(processNames(tables))"
        case .JOIN:
            break
        case .WHERE(let column, let condition):
            return "WHERE \(column.columnName) \(condition)"
        case .ORDER(let columns):
            let columnText = columns.map({ return "\($0)" }).joinWithSeparator(", ")
            return "ORDER BY \(columnText)"
        case .LIMIT(let count, let offset):
            return "LIMIT \(count) OFFSET \(offset)"
        case .GROUP(let columns):
            return "GROUP BY \(processNames(columns))"
        case .HAVING(let column, let condition):
            return "HAVING \(column.columnName) \(condition)"
        }
        return ""
    }
}