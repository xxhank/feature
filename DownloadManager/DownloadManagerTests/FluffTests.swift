//
//  FluffTests.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/6/3.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import XCTest
@testable import DownloadManager

class FluffTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSelectCaluse() {
        var SELECT = FluffClause.SELECT(distinct: false, columns: ["name"])

        XCTAssert("\(SELECT)" == "SELECT \"name\"", "\(SELECT)")

        SELECT = FluffClause.SELECT(distinct: true, columns: ["name"])

        XCTAssert("\(SELECT)" == "SELECT DISTINCT \"name\"", "\(SELECT)")

        SELECT = FluffClause.SELECT(distinct: false, columns: ["name", "age"])

        XCTAssert("\(SELECT)" == "SELECT \"name\", \"age\"", "\(SELECT)")

        SELECT = FluffClause.SELECT(distinct: false, columns: ["*"])

        XCTAssert("\(SELECT)" == "SELECT \"*\"", "\(SELECT)")
    }

    func testFROMCaluse() {
        var FROM = FluffClause.FROM(tables: ["table1"])
        XCTAssert("\(FROM)" == "FROM \"table1\"")

        FROM = FluffClause.FROM(tables: ["table1", "table2"])
        XCTAssert("\(FROM)" == "FROM \"table1\", \"table2\"")
    }

    func testORDERClause() {
        let ORDER = FluffClause.ORDER(columns: [
            FluffColumn.Column_ASC(name: "name"),
            FluffColumn.Column_DESC(name: "age"),
            FluffColumn.Column(name: "addr", order: .ASC),
            FluffColumn.Column(name: "wage", order: .DESC)
        ])

        XCTAssert(ORDER.description == "ORDER BY \"name\" ASC, \"age\" DESC, \"addr\" ASC, \"wage\" DESC", ORDER.description)
    }

    func testLimitCaluse() {
        let LIMIT = FluffClause.LIMIT(count: 1, offset: 0)
        XCTAssert(LIMIT.description == "LIMIT 1 OFFSET 0", LIMIT.description)
    }

    func testNumberWhere() {
        var WHERE = FluffClause.WHERE(column: "albumid", condition: .Equal(value: 1))
        XCTAssert(WHERE.description == "WHERE \"albumid\" = 1", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .NotEqual(value: 1))
        XCTAssert(WHERE.description == "WHERE \"albumid\" != 1", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .Less(value: 1))
        XCTAssert(WHERE.description == "WHERE \"albumid\" < 1", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .Greater(value: 1))
        XCTAssert(WHERE.description == "WHERE \"albumid\" > 1", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .LessOrEqual(value: 1))
        XCTAssert(WHERE.description == "WHERE \"albumid\" <= 1", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .GreaterOrEqual(value: 1))
        XCTAssert(WHERE.description == "WHERE \"albumid\" >= 1", WHERE.description)
    }

    func testInWhere() {
        var WHERE = FluffClause.WHERE(column: "albumid", condition: .IN_Query(query: "query"))
        XCTAssert(WHERE.description == "WHERE \"albumid\" IN (query)", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .IN_Values(values: [1, 2, 3]))
        XCTAssert(WHERE.description == "WHERE \"albumid\" IN (1, 2, 3)", WHERE.description)
    }

    func testLikeWhere() {
        var WHERE = FluffClause.WHERE(column: "albumid", condition: .LIKE(pattern: "wangchao%", escape: nil))
        XCTAssert(WHERE.description == "WHERE \"albumid\" LIKE \"wangchao%\"", WHERE.description)

        WHERE = FluffClause.WHERE(column: "albumid", condition: .LIKE(pattern: "wangchao%", escape: FluffLikeWildcard.ANY))
        XCTAssert(WHERE.description == "WHERE \"albumid\" LIKE \"wangchao%\" ESCAPE \"%\"", WHERE.description)
    }

    func testGLOBWhere() {
        let WHERE = FluffClause.WHERE(column: "albumid", condition: .GLOB(regex: "wang*"))
        XCTAssert(WHERE.description == "WHERE \"albumid\" GLOB \"wang*\"", WHERE.description)
    }

    func testInsert() {
        var INSERT = FluffClause.INSERT(table: "table1", columns: ["name", "age", "addr"], values: ["wangchao", 30, "beijing"])

        XCTAssert(INSERT.description == "INSERT INTO \"table1\" (\"name\", \"age\", \"addr\") VALUES (\"wangchao\", 30, \"beijing\")", INSERT.description)

        INSERT = FluffClause.INSERT_ROWS(table: "table1", columns: ["name", "age", "addr"], values: [
            ["wangchao1", 30, "beijing"],
            ["wangchao2", 31, "beijing"],
            ["wangchao3", 32, "beijing"]
        ])

        XCTAssert(INSERT.description == "INSERT INTO \"table1\" (\"name\", \"age\", \"addr\") VALUES (\"wangchao1\", 30, \"beijing\"), (\"wangchao2\", 31, \"beijing\"), (\"wangchao3\", 32, \"beijing\")", INSERT.description)

        INSERT = FluffClause.INSERT_QUERY(table: "table1", query: "SELECT * FROM table2")
        XCTAssert(INSERT.description == "INSERT INTO \"table1\" SELECT * FROM table2", INSERT.description)
    }

    func testUpdate() {
        let UPDATE = FluffClause.UPDATE(table: "table1", values: ["name": "wangchao2", "addr": "Beijing xizhimeng"], WHERE: "WHERE \"name\" = \"wangchao\"", ORDER: nil, LIMIT: nil)
        XCTAssert(UPDATE.description == "UPDATE \"table1\" SET \"addr\" = \"Beijing xizhimeng\", \"name\" = \"wangchao2\" WHERE \"name\" = \"wangchao\"", UPDATE.description)
    }

    func testDelete() {
        let DELETE = FluffClause.DELETE(table: "table1", WHERE: "WHERE \"name\" = \"wangchao\"", ORDER: nil, LIMIT: nil)
        XCTAssert(DELETE.description == "DELETE FROM \"table1\" WHERE \"name\" = \"wangchao\"", DELETE.description)
    }
}
