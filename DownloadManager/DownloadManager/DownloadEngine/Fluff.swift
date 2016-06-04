//
//  Fluff.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/6/3.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import Foundation

func fluff_reduceNames(names: [String], separator: String = ",\n ") -> String {
    return names.map({ return $0.columnName }).joinWithSeparator(separator)
}

func fluff_reduceValues(values: [Any], separator: String = ",\n ") -> String {
    var results = [String]()
    for value in values {
        if let stringValue = value as? String {
            results.append("\(stringValue.columnValue)")
        } else {
            results.append("\(value)")
        }
    }

    return results.joinWithSeparator(separator)
}

func fluff_reduceNameAndValues(values: [String: Any], separator: String = ",\n ") -> String {
    var results = [String]()
    for (key, value) in values {
        if let stringValue = value as? String {
            results.append("\(key.columnName) = \(stringValue.columnValue)")
        } else {
            results.append("\(key.columnName) = \(value)")
        }
    }

    return results.joinWithSeparator(separator)
}

public enum FluffOrder: String, CustomStringConvertible {
    case ASC = "ASC"
    case DESC = "DESC"

    public var description: String {
        return self.rawValue
    }
}

public enum FluffType: String, CustomStringConvertible {
    case NULL = "NULL"
    case INTEGER = "INTEGER"// 1,2,3,4,8
    case REAL = "REAL"
    case TEXT = "TEXT"
    case BLOB = "BLOB"

    public var description: String {
        return self.rawValue
    }
}

// MARK: - FluffJOIN
public enum FluffJOIN: CustomStringConvertible {
    case INNER(table1: String, column1: String, table2: String, column2: String)
    case LEFT(table1: String, column1: String, table2: String, column2: String)
    /// NOT SUPPORT
    /// case SELF
    public var description: String {
        switch self {
        case .INNER(let table1, let column1, let table2, let column2):
            return "INNER JOIN \(table2.columnName) ON \(table2.columnName).\(column2.columnName) = \(table1.columnName).\(column1.columnName)"
        case .LEFT(let table1, let column1, let table2, let column2):
            return "LEFT JOIN \(table2.columnName) ON \(table2.columnName).\(column2.columnName) = \(table1.columnName).\(column1.columnName)"
        }
    }
}

// MARK: - FluffLikeWildcard
/**
 通配符

 - ANY: 任意多个字符
 - ONE: 单个字符
 */
public enum FluffLikeWildcard: String, CustomStringConvertible {
    case ANY = "%"
    case ONE = "_"

    public var description: String {
        return self.rawValue
    }
}

/**
 通配符

 - ANY: 任意多个字符
 - ONE: 单个字符
 */
public enum FluffGLOBWildcard: String, CustomStringConvertible {
    case ANY = "*"
    case ONE = "?"

    public var description: String {
        return self.rawValue
    }
}

// MARK: - FluffLogic
public enum FluffLogic: String, CustomStringConvertible {
    case AND = "AND"
    case OR = "OR"
    /// NOT SUPPORT case ALL = "ALL"
    /// NOT SUPPORT case ANY = "ANY"

    public var description: String {
        return self.rawValue
    }
}

// MARK: - FluffCondition
// TODO:: albumid IS NULL;
public enum FluffCondition: CustomStringConvertible {
    case Equal(value: Any)
    case NotEqual(value: Any)
    case Less(value: Any)
    case Greater(value: Any)
    case LessOrEqual(value: Any)
    case GreaterOrEqual(value: Any)

    case BETWEEN(min: Any, max: Any, negative: Bool?)
    case EXISTS
    case IN_Values(values: [Any], negative: Bool?)
    case IN_Query(query: String, negative: Bool?)
    case LIKE(pattern: String, escape: FluffLikeWildcard?, negative: Bool?)
    case GLOB(regex: String, negative: Bool?)

    public var description: String {
        switch self {
        case .Equal(let value): return "= \(value)"
        case .NotEqual(let value): return "!= \(value)"
        case .Less(let value): return "< \(value)"
        case .Greater(let value): return "> \(value)"
        case .LessOrEqual(let value): return "<= \(value)" case .GreaterOrEqual(let value): return ">= \(value)"

        case .BETWEEN(let min, let max, let negative):
            let prefix = (negative ?? false) ? "NOT " : ""
            return "\(prefix)BETWEEN \(min) AND \(max)"
        case .EXISTS:
            break
        case .IN_Values(let values, let negative):
            let prefix = (negative ?? false) ? "NOT " : ""
            return "\(prefix)IN (\(fluff_reduceValues(values, separator: ", ")))"
        case .IN_Query(let query, let negative):
            let prefix = (negative ?? false) ? "NOT " : ""
            return "\(prefix)IN (\(query))"
        case .LIKE(let pattern, let escape, let negative):
            let prefix = (negative ?? false) ? "NOT " : ""
            if let escape_ = escape {
                return "\(prefix)LIKE \(pattern.columnValue) ESCAPE \"\(escape_.rawValue)\""
            } else {
                return "\(prefix)LIKE \(pattern.columnValue)"
            }
        case .GLOB(let regex, let negative):
            let prefix = (negative ?? false) ? "NOT " : ""
            return "\(prefix)GLOB \(regex.columnValue)"
        }
        return ""
    }
}

// MARK: - FluffColumn
public enum FluffColumn: CustomStringConvertible {
    case Column(name: String, order: FluffOrder?)
    case Column_ASC(name: String)
    case Column_DESC(name: String)

    public var description: String {
        switch self {
        case .Column(let name, let order):
            if let order_ = order {
                return "\(name.columnName) \(order_)"
            } else {
                return "\(name.columnName)"
            }
        case .Column_ASC(let name):
            return "\(name.columnName) \(FluffOrder.ASC)"
        case .Column_DESC(let name):
            return "\(name.columnName) \(FluffOrder.DESC)"
        }
    }
}

// MARK: - FluffForeignKeyAction
public enum FluffForeignKeyAction: String, CustomStringConvertible {
    case SET_NULL = "SET NULL"
    case SET_DEFAULT = "SET DEFAULT"
    case RESTRICT = "RESTRICT"
    case CASCADE = "CASCADE"
    case NO_ACTION = "NO ACTION"

    public var description: String {
        return self.rawValue
    }
}

// MARK: - FluffForeignKeyEvent
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

// MARK: - FluffConstraint
public enum FluffConstraint: CustomStringConvertible {
    case PRIMARY_KEY
    case UNIQUE
    case NOT_NULL
    case CHECK
    case FOREIGN_KEY(cloumn: String, reference: (table: String, column: String), events: [FluffForeignKeyEvent]?)

    public var description: String {
        switch self {
        case .PRIMARY_KEY: return "PRIMARY KEY"
        case .UNIQUE: return "UNIQUE"
        case .NOT_NULL: return "NOT NULL"
        case .CHECK: return "CHECK"
        case .FOREIGN_KEY(let cloumn, let reference, let events):
            if let events_ = events {
                let eventsText = events_.map({ return $0.description }).joinWithSeparator(" ")
                return "FOREIGN KEY (\(cloumn.columnName)) REFERENCES \(reference.0.columnName)(\(reference.1.columnName)) \(eventsText)"
            } else {
                return "FOREIGN KEY (\(cloumn.columnName)) REFERENCES \(reference.0.columnName)(\(reference.1.columnName))"
            }
        }
    }
}

// MARK: - FluffTableConstraint
public enum FluffTableConstraint: CustomStringConvertible {
    case TABLE_PRIMARY_KEY(columns: [String])
    case TABLE_FOREIGN_KEY(cloumn: String, reference: (table: String, column: String), events: [FluffForeignKeyEvent]?)
    public var description: String {
        switch self {
        case .TABLE_PRIMARY_KEY(let columns):
            return "PRIMARY KEY (\(fluff_reduceNames(columns, separator: ", ")))"
        case .TABLE_FOREIGN_KEY(let cloumn, let reference, let events):
            if let events_ = events {
                let eventsText = events_.map({ return $0.description }).joinWithSeparator(" ")
                return "FOREIGN KEY (\(cloumn.columnName)) REFERENCES \(reference.0.columnName) (\(reference.1.columnName))\n\(eventsText)"
            } else {
                return "FOREIGN KEY (\(cloumn.columnName)) REFERENCES \(reference.0.columnName) (\(reference.1.columnName))"
            }
        }
    }
}

// MARK: - FluffClause
public struct FluffClause {
    static func TRANSACTION(SQLs: [String]) -> String {
        let SQLsText = SQLs.joinWithSeparator("\n\n")
        return "BEGIN TRANSACTION;\n\n\(SQLsText)\n\nCOMMIT;"
    }
}

// MARK: - TABLE
extension FluffClause {
    static func CREATE_TABLE(table table: String,
        columns: [(name: String, type: FluffType, constraints: [FluffConstraint])], constraints: [FluffTableConstraint]? = nil, safe: Bool = true) -> String {
            let IF_NOT_EXISTS = safe ? " IF NOT EXISTS" : ""
            var constraintsText = columns.map({ (column) -> String in
                if column.constraints.count > 0 {
                    let constraintsText = column.constraints.map({ return $0.description }).joinWithSeparator(" ")
                    return "\(column.name.columnName) \(column.type) \(constraintsText)"
                } else {
                    return "\(column.name.columnName) \(column.type)"
                }
            })
            if let constraints_ = constraints {
                constraintsText.appendContentsOf(constraints_.map({ $0.description }))
            }

            return "CREATE TABLE\(IF_NOT_EXISTS) \(table.columnName) (\n\(constraintsText.joinWithSeparator(",\n"))\n);"
    }

    static func RENAME_TABLE(from from: String, to: String) -> String {
        return "ALTER TABLE \(from.columnName) RENAME TO \(to.columnName);"
    }

    static func ALTER_TABLE(table table: String, column: (name: String, type: FluffType, constraints: [FluffConstraint])) -> String {
        var columnText = ""
        if column.constraints.count > 0 {
            let constraintsText = column.constraints.map({ return $0.description }).joinWithSeparator(" ")
            columnText = "\(column.name.columnName) \(column.type) \(constraintsText);"
        } else {
            columnText = "\(column.name.columnName) \(column.type);"
        }

        return "ALTER TABLE \(table.columnName) ADD COLUMN \(columnText)"
    }

    static func DROP_TABLE(table table: String, safe: Bool) -> String {
        if safe {
            return "DROP TABLE IF EXISTS \(table.columnName)"
        } else {
            return "DROP TABLE \(table.columnName)"
        }
    }
}

// MARK: - ROW
extension FluffClause {
    static func SELECT(
        tables tables: [String],
        columns: [String],
        distinct: Bool = true,
        JOIN: String? = nil,
        WHERE: String? = nil,
        ORDER: String? = nil,
        LIMIT: String? = nil,
        GROUP: String? = nil,
        HAVING: String? = nil) -> String {
            var SQLs = [String]()
            let columnsText = fluff_reduceNames(columns)
            if distinct {
                SQLs.append("SELECT DISTINCT\n \(columnsText)")
            } else {
                SQLs.append("SELECT\n \(columnsText)")
            }

            SQLs.append("FROM\n \(fluff_reduceNames(tables))")

            if let JOIN_ = JOIN {
                SQLs.append(" \(JOIN_)")
            }
            if WHERE != nil {
                SQLs.append(WHERE!)
            }
            if ORDER != nil {
                SQLs.append(ORDER!)
            }
            if LIMIT != nil {
                SQLs.append(LIMIT!)
            }
            if GROUP != nil {
                SQLs.append(GROUP!)
            }
            if HAVING != nil {
                SQLs.append(HAVING!)
            }
            return SQLs.joinWithSeparator("\n") + ";"
    }

    static func INSERT(table table: String, columns: [String], values: [Any]) -> String {
        return "INSERT INTO \(table.columnName) (\n \(fluff_reduceNames(columns)))\nVALUES\n (\n \(fluff_reduceValues(values)));"
    }

    static func INSERT(table table: String, columns: [String], values: [[Any]]) -> String {
        let rowValues = values.map({ return "(\n \(fluff_reduceValues($0)))" })
        return "INSERT INTO \(table.columnName) (\n \(fluff_reduceNames(columns)))\nVALUES\n \(rowValues.joinWithSeparator(",\n "));"
    }

    static func INSERT(table table: String, query: String) -> String {
        return "INSERT INTO \(table.columnName) \(query)"
    }

    static func UPDATE(table table: String, values: [String: Any], WHERE: String?, ORDER: String?, LIMIT: String?) -> String {
        var SQLs = [String]()
        if WHERE != nil {
            SQLs.append(WHERE!)
        }
        if ORDER != nil {
            SQLs.append(ORDER!)
        }
        if LIMIT != nil {
            SQLs.append(LIMIT!)
        }
        return "UPDATE \(table.columnName)\nSET\n \(fluff_reduceNameAndValues(values))\n\(SQLs.joinWithSeparator("\n"));"
    }
    
    static func DELETE(table table: String, WHERE: String?, ORDER: String?, LIMIT: String?) -> String {
        var SQLs = [String]()
        if WHERE != nil {
            SQLs.append(WHERE!)
        }
        if ORDER != nil {
            SQLs.append(ORDER!)
        }
        if LIMIT != nil {
            SQLs.append(LIMIT!)
        }

        if SQLs.count > 0 {
            return "DELETE FROM\n \(table.columnName)\n\(SQLs.joinWithSeparator("\n"));"
        } else {
            return "DELETE FROM\n \(table.columnName);"
        }
    }
}

// MARK: - SUFFIX
extension FluffClause {
    static func WHERE(columns columns: [(column: String, condition: FluffCondition, logic: FluffLogic?)]) -> String {
        let columnsText = columns.map({ (column) -> String in
            if column.logic != nil {
                return "\(column.logic!) \(column.column.columnName) \(column.condition)"
            } else {
                return "\(column.column.columnName) \(column.condition)"
            }
        }).joinWithSeparator("\n")
        return "WHERE\n \(columnsText)"
    }

    static func HAVING(columns columns: [(column: String, condition: FluffCondition, logic: FluffLogic?)]) -> String {
        let columnsText = columns.map({ (column) -> String in
            if column.logic != nil {
                return "\(column.logic!) \(column.column.columnName) \(column.condition)"
            } else {
                return "\(column.column.columnName) \(column.condition)"
            }
        }).joinWithSeparator("\n")
        return "HAVING \(columnsText)"
    }

    static func ORDER(columns columns: [FluffColumn]) -> String {
        let columnText = columns.map({ return "\($0)" }).joinWithSeparator(",\n ")
        return "ORDER BY\n \(columnText)"
    }

    static func LIMIT(count count: Int, offset: Int? = nil) -> String {
        if let offset_ = offset {
            return "LIMIT \(count) OFFSET \(offset_)"
        } else {
            return "LIMIT \(count)"
        }
    }

    static func GROUP(columns columns: [String]) -> String {
        return "GROUP BY\n \(fluff_reduceNames(columns))"
    }
}