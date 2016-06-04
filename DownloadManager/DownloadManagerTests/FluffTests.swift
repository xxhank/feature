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
        var SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["trackid", "name", "composer", "unitprice"],
            distinct: false,
            JOIN: nil,
            WHERE: nil,
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)

        XCTAssert(SQL == "SELECT\n \"trackid\",\n \"name\",\n \"composer\",\n \"unitprice\"\nFROM\n \"tracks\";", SQL)

        SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["name", "milliseconds", "albumid"],
            distinct: false,
            JOIN: nil,
            WHERE: nil,
            ORDER: FluffClause.ORDER(columns: [
                FluffColumn.Column(name: "albumid", order: .ASC),
                FluffColumn.Column(name: "milliseconds", order: .DESC)
            ]),
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"name\",\n \"milliseconds\",\n \"albumid\"\nFROM\n \"tracks\"\nORDER BY\n \"albumid\" ASC,\n \"milliseconds\" DESC;", SQL)

        SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["trackId", "name"],
            distinct: false,
            JOIN: nil,
            WHERE: nil,
            ORDER: nil,
            LIMIT: FluffClause.LIMIT(count: 10, offset: 10),
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"trackId\",\n \"name\"\nFROM\n \"tracks\"\nLIMIT 10 OFFSET 10;", SQL)

        SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["trackid", "name", "bytes"],
            distinct: false,
            JOIN: nil,
            WHERE: nil,
            ORDER: FluffClause.ORDER(columns: [
                FluffColumn.Column(name: "bytes", order: .DESC)]),
            LIMIT: FluffClause.LIMIT(count: 10, offset: nil),
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"trackid\",\n \"name\",\n \"bytes\"\nFROM\n \"tracks\"\nORDER BY\n \"bytes\" DESC\nLIMIT 10;", SQL)

        SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["name", "milliseconds", "bytes", "albumid"],
            distinct: false,
            JOIN: nil,
            WHERE: FluffClause.WHERE(columns: [("albumid", FluffCondition.Equal(value: 1), nil)]),
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"name\",\n \"milliseconds\",\n \"bytes\",\n \"albumid\"\nFROM\n \"tracks\"\nWHERE\n \"albumid\" = 1;", SQL)
    }

    func testSelectWithAND() {
        let SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["name", "milliseconds", "bytes", "albumid"],
            distinct: false,
            JOIN: nil,
            WHERE: FluffClause.WHERE(columns: [
                ("albumid", FluffCondition.Equal(value: 1), nil),
                ("milliseconds", FluffCondition.Greater(value: 250000), .AND)]),
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"name\",\n \"milliseconds\",\n \"bytes\",\n \"albumid\"\nFROM\n \"tracks\"\nWHERE\n \"albumid\" = 1\nAND \"milliseconds\" > 250000;", SQL)
    }

    func testSelectWithIn() {
        var SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["name", "albumid", "mediatypeid"],
            distinct: false,
            JOIN: nil,
            WHERE: FluffClause.WHERE(columns: [
                ("mediatypeid", FluffCondition.IN_Values(values: [2, 3], negative: nil), nil),
            ]),
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"name\",\n \"albumid\",\n \"mediatypeid\"\nFROM\n \"tracks\"\nWHERE\n \"mediatypeid\" IN (2, 3);", SQL)

        SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["trackid", "name", "genreid"],
            distinct: false,
            JOIN: nil,
            WHERE: FluffClause.WHERE(columns: [
                ("genreid", FluffCondition.IN_Values(values: [1, 2, 3], negative: true), nil),
            ]),
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"trackid\",\n \"name\",\n \"genreid\"\nFROM\n \"tracks\"\nWHERE\n \"genreid\" NOT IN (1, 2, 3);", SQL)
    }

    func testSelectWithLIKE() {
        let SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["name", "albumid", "composer"],
            distinct: false,
            JOIN: nil,
            WHERE: FluffClause.WHERE(columns: [
                ("composer", FluffCondition.LIKE(pattern: "%Smith%", escape: nil, negative: nil), nil),
            ]),
            ORDER: FluffClause.ORDER(columns: [FluffColumn.Column(name: "albumid", order: nil)]),
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"name\",\n \"albumid\",\n \"composer\"\nFROM\n \"tracks\"\nWHERE\n \"composer\" LIKE \"%Smith%\"\nORDER BY\n \"albumid\";", SQL)
    }

    func testSelectWithInnerJoin() {
        var SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["trackid", "name", "title"],
            distinct: false,
            JOIN: FluffJOIN.INNER(table1: "tracks", column1: "albumid", table2: "albums", column2: "albumid").description,
            WHERE: nil,
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"trackid\",\n \"name\",\n \"title\"\nFROM\n \"tracks\"\n INNER JOIN \"albums\" ON \"albums\".\"albumid\" = \"tracks\".\"albumid\";", SQL)

        SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["trackid", "tracks", "albums", "artists"],
            distinct: false,
            JOIN: [
                FluffJOIN.INNER(table1: "tracks", column1: "albumid", table2: "albums", column2: "albumid").description,
                FluffJOIN.INNER(table1: "albums", column1: "artistid", table2: "artists", column2: "artistid").description
            ].joinWithSeparator("\n "),
            WHERE: nil,
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"trackid\",\n \"tracks\",\n \"albums\",\n \"artists\"\nFROM\n \"tracks\"\n INNER JOIN \"albums\" ON \"albums\".\"albumid\" = \"tracks\".\"albumid\"\n INNER JOIN \"artists\" ON \"artists\".\"artistid\" = \"albums\".\"artistid\";", SQL)
    }

    func testSelectWithLeftJoin() {
        let SQL = FluffClause.SELECT(
            tables: ["artists"],
            columns: ["artists", "albumid"],
            distinct: false,
            JOIN: FluffJOIN.LEFT(table1: "artists", column1: "artistid", table2: "albums", column2: "artistid").description,
            WHERE: nil,
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"artists\",\n \"albumid\"\nFROM\n \"artists\"\n LEFT JOIN \"albums\" ON \"albums\".\"artistid\" = \"artists\".\"artistid\";", SQL)
    }

    func testSelectGroupBy() {
        let SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["mediatypeid", "genreid"],
            distinct: false,
            JOIN: nil,
            WHERE: nil,
            ORDER: nil,
            LIMIT: nil,
            GROUP: FluffClause.GROUP(columns: ["mediatypeid", "genreid"]),
            HAVING: nil)
        XCTAssert(SQL == "SELECT\n \"mediatypeid\",\n \"genreid\"\nFROM\n \"tracks\"\nGROUP BY\n \"mediatypeid\",\n \"genreid\";", SQL)
    }

    func testSelectHaving() {
        let SQL = FluffClause.SELECT(
            tables: ["tracks"],
            columns: ["albumid"],
            distinct: false,
            JOIN: nil,
            WHERE: nil,
            ORDER: nil,
            LIMIT: nil,
            GROUP: nil,
            HAVING: FluffClause.HAVING(columns: [
                ("albumid", FluffCondition.BETWEEN(min: 18, max: 20, negative: nil), nil)
            ])
        )
        XCTAssert(SQL == "SELECT\n \"albumid\"\nFROM\n \"tracks\"\nHAVING \"albumid\" BETWEEN 18 AND 20;", SQL)
    }
    func testORDERClause() {
        let ORDER = FluffClause.ORDER(columns: [
            FluffColumn.Column_ASC(name: "name"),
            FluffColumn.Column_DESC(name: "age"),
            FluffColumn.Column(name: "addr", order: .ASC),
            FluffColumn.Column(name: "wage", order: .DESC)
        ])

        XCTAssert(ORDER == "ORDER BY\n \"name\" ASC,\n \"age\" DESC,\n \"addr\" ASC,\n \"wage\" DESC", ORDER)
    }

    func testLimitCaluse() {
        let LIMIT = FluffClause.LIMIT(count: 1, offset: 0)
        XCTAssert(LIMIT == "LIMIT 1 OFFSET 0", LIMIT)
    }

    func testWhereNumberCompare() {
        var WHERE = FluffClause.WHERE(columns: [("albumid", .Equal(value: 1), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" = 1", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .NotEqual(value: 1), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" != 1", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .Less(value: 1), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" < 1", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .Greater(value: 1), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" > 1", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .LessOrEqual(value: 1), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" <= 1", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .GreaterOrEqual(value: 1), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" >= 1", WHERE)
    }

    func testWhereIn() {
        var WHERE = FluffClause.WHERE(columns: [("albumid", .IN_Query(query: "query", negative: nil), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" IN (query)", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .IN_Values(values: [1, 2, 3], negative: nil), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" IN (1, 2, 3)", WHERE)
    }

    func testWhereLike() {
        var WHERE = FluffClause.WHERE(columns: [("albumid", .LIKE(pattern: "wangchao%", escape: nil, negative: nil), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" LIKE \"wangchao%\"", WHERE)

        WHERE = FluffClause.WHERE(columns: [("albumid", .LIKE(pattern: "wangchao%", escape: FluffLikeWildcard.ANY, negative: nil), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" LIKE \"wangchao%\" ESCAPE \"%\"", WHERE)
    }

    func testWhereGLOB() {
        let WHERE = FluffClause.WHERE(columns: [("albumid", .GLOB(regex: "wang*", negative: nil), nil)])
        XCTAssert(WHERE == "WHERE\n \"albumid\" GLOB \"wang*\"", WHERE)
    }

    func testInsert() {
        var INSERT = FluffClause.INSERT(table: "table1", columns: ["name", "age", "addr"], values: ["wangchao", 30, "beijing"])

        XCTAssert(INSERT == "INSERT INTO \"table1\" (\n \"name\",\n \"age\",\n \"addr\")\nVALUES\n (\n \"wangchao\",\n 30,\n \"beijing\");", INSERT)

        INSERT = FluffClause.INSERT(table: "table1", columns: ["name", "age", "addr"], values: [
            ["wangchao1", 30, "beijing"],
            ["wangchao2", 31, "beijing"],
            ["wangchao3", 32, "beijing"]
        ])

        XCTAssert(INSERT == "INSERT INTO \"table1\" (\n \"name\",\n \"age\",\n \"addr\")\nVALUES\n (\n \"wangchao1\",\n 30,\n \"beijing\"),\n (\n \"wangchao2\",\n 31,\n \"beijing\"),\n (\n \"wangchao3\",\n 32,\n \"beijing\");", INSERT)

        INSERT = FluffClause.INSERT(table: "table1", query: "SELECT * FROM table2")
        XCTAssert(INSERT == "INSERT INTO \"table1\" SELECT * FROM table2", INSERT)
    }

    func testUpdate() {
        let UPDATE = FluffClause.UPDATE(
            table: "employees",
            values: [
                "city": "Toronto",
                "state": "ON",
                "postalcode": "M5P 2N7"],
            WHERE: FluffClause.WHERE(columns: [("employeeid", FluffCondition.Equal(value: 4), nil)]),
            ORDER: nil,
            LIMIT: nil)
        XCTAssert(UPDATE == "UPDATE \"employees\"\nSET\n \"city\" = \"Toronto\",\n \"postalcode\" = \"M5P 2N7\",\n \"state\" = \"ON\"\nWHERE\n \"employeeid\" = 4;", UPDATE)
    }

    func testDelete() {
        let DELETE = FluffClause.DELETE(table: "table1", WHERE: "WHERE \"name\" = \"wangchao\"", ORDER: nil, LIMIT: nil)
        XCTAssert(DELETE == "DELETE FROM\n \"table1\"\nWHERE \"name\" = \"wangchao\";", DELETE)
    }

    func testCreateTable() {
        var CREATE_TABLE = FluffClause.CREATE_TABLE(
            table: "contacts",
            columns: [
                ("contact_id", FluffType.INTEGER, [FluffConstraint.PRIMARY_KEY]),
                ("first_name", FluffType.TEXT, [FluffConstraint.NOT_NULL]),
                ("last_name", FluffType.TEXT, [FluffConstraint.NOT_NULL]),
                ("email", FluffType.TEXT, [FluffConstraint.NOT_NULL, FluffConstraint.UNIQUE]),
                ("phone", FluffType.TEXT, [FluffConstraint.NOT_NULL, FluffConstraint.UNIQUE]),
            ], constraints: [
            ], safe: false)

        XCTAssert(CREATE_TABLE == "CREATE TABLE \"contacts\" (\n\"contact_id\" INTEGER PRIMARY KEY,\n\"first_name\" TEXT NOT NULL,\n\"last_name\" TEXT NOT NULL,\n\"email\" TEXT NOT NULL UNIQUE,\n\"phone\" TEXT NOT NULL UNIQUE\n);", CREATE_TABLE)

        CREATE_TABLE = FluffClause.CREATE_TABLE(
            table: "contacts",
            columns: [
                ("contact_id", FluffType.INTEGER, [FluffConstraint.PRIMARY_KEY]),
                ("first_name", FluffType.TEXT, [FluffConstraint.NOT_NULL]),
                ("last_name", FluffType.TEXT, [FluffConstraint.NOT_NULL]),
                ("email", FluffType.TEXT, [FluffConstraint.NOT_NULL, FluffConstraint.UNIQUE]),
                ("phone", FluffType.TEXT, [FluffConstraint.NOT_NULL, FluffConstraint.UNIQUE]),
            ], constraints: [
            ], safe: true)

        XCTAssert(CREATE_TABLE == "CREATE TABLE IF NOT EXISTS \"contacts\" (\n\"contact_id\" INTEGER PRIMARY KEY,\n\"first_name\" TEXT NOT NULL,\n\"last_name\" TEXT NOT NULL,\n\"email\" TEXT NOT NULL UNIQUE,\n\"phone\" TEXT NOT NULL UNIQUE\n);", CREATE_TABLE)

        CREATE_TABLE = FluffClause.CREATE_TABLE(
            table: "contact_groups",
            columns: [
                ("contact_id", FluffType.INTEGER, []),
                ("group_id", FluffType.INTEGER, []),
            ], constraints: [
                FluffTableConstraint.TABLE_PRIMARY_KEY(columns: ["contact_id", "group_id"]),
                FluffTableConstraint.TABLE_FOREIGN_KEY(
                    cloumn: "contact_id",
                    reference: (table: "contacts", column: "contact_id"),
                    events: [
                        FluffForeignKeyEvent.DELETE(action: .CASCADE),
                        FluffForeignKeyEvent.UPDATE(action: .NO_ACTION)
                ]),
                FluffTableConstraint.TABLE_FOREIGN_KEY(
                    cloumn: "group_id",
                    reference: (table: "groups", column: "group_id"),
                    events: [
                        FluffForeignKeyEvent.DELETE(action: .CASCADE),
                        FluffForeignKeyEvent.UPDATE(action: .NO_ACTION)
                ])
            ], safe: true)

        XCTAssert(CREATE_TABLE == "CREATE TABLE IF NOT EXISTS \"contact_groups\" (\n\"contact_id\" INTEGER,\n\"group_id\" INTEGER,\nPRIMARY KEY (\"contact_id\", \"group_id\"),\nFOREIGN KEY (\"contact_id\") REFERENCES \"contacts\" (\"contact_id\")\nON DELETE CASCADE ON UPDATE NO ACTION,\nFOREIGN KEY (\"group_id\") REFERENCES \"groups\" (\"group_id\")\nON DELETE CASCADE ON UPDATE NO ACTION\n);", CREATE_TABLE)
    }

    func testRenameTable() {
        let RENAME = FluffClause.RENAME_TABLE(from: "devices", to: "equipment")
        XCTAssert(RENAME == "ALTER TABLE \"devices\" RENAME TO \"equipment\";", RENAME)
    }

    func testAlterTable() {
        let ALTER = FluffClause.ALTER_TABLE(table: "equipment", column: (name: "location", type: .TEXT, constraints: []))
        XCTAssert(ALTER == "ALTER TABLE \"equipment\" ADD COLUMN \"location\" TEXT;", ALTER)
    }

    func testDropTable() {
        var SQL = FluffClause.DROP_TABLE(table: "addresses", safe: false)
        XCTAssert(SQL == "DROP TABLE \"addresses\"", SQL)

        SQL = FluffClause.DROP_TABLE(table: "addresses", safe: true)
        XCTAssert(SQL == "DROP TABLE IF EXISTS \"addresses\"", SQL)
    }
}
