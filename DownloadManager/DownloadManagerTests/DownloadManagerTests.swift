//
//  DownloadManagerTests.swift
//  DownloadManagerTests
//
//  Created by wangchao9 on 16/5/31.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import XCTest
@testable import DownloadManager

class DownloadManagerTests: XCTestCase {
    let manager = DownloadManager.manager("test.db")
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    // MARK: - queue manager
    func testLoadFromNotExistDatabase() {

    }

    func testQueueManager() {
        let count = manager.numberOfTasks
        let task = DownloadTask()
        manager.append(task)
        XCTAssertEqual(count + 1, manager.numberOfTasks)

        manager.remove(task)
        XCTAssertEqual(count, manager.numberOfTasks)

        manager.append(task)
        let task2 = DownloadTask()
        manager.append(task2)
        XCTAssertEqual(count + 1, manager.numberOfTasks)

        manager.append(task2, allowDuplicate: true)
        XCTAssertEqual(count + 2, manager.numberOfTasks)

        if let query = manager.taskAtIndex(count) {
            XCTAssert(query === task)
        } else {
            XCTAssert(false)
        }

        XCTAssert(manager.taskAtIndex(manager.numberOfTasks + 1) == nil)
    }
}
