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
    }

    override func tearDown() {
        super.tearDown()
    }

    func testDownloadTaskStatus() {
        XCTAssert(DownloadTaskStatus(stringValue: "") == DownloadTaskStatus.Waiting)
    }
    // MARK: Database
    func testLoadFromDatabase() {
        let databaseName = "test-\(arc4random()).db"
        let writer = DownloadManager.manager(databaseName)

        var key = NSUUID().UUIDString
        writer.append(DownloadTask(key: key, url: "http://wwww.baidu.com/1"))
        key = NSUUID().UUIDString
        writer.append(DownloadTask(key: key, url: "http://wwww.baidu.com/2"))
        key = NSUUID().UUIDString
        writer.append(DownloadTask(key: key, url: "http://wwww.baidu.com/3"))

        let reader = DownloadManager.manager(databaseName)
        XCTAssert(reader.numberOfTasks == 3)
    }
    // MARK: - queue manager

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

        manager.removeAll()
        XCTAssert(manager.numberOfTasks == 0)
    }

    // MARK: dispatch
    func testTaskDispatch() {
        let databaseName = "test-\(arc4random()).db"
        let dispatch = DownloadManager.manager(databaseName)
        dispatch.MaxNumberOfConcurrentTasks = 3

        for index in 1...10 {
            let key = NSUUID().UUIDString
            dispatch.append(DownloadTask(key: key, url: "http://wwww.baidu.com/\(index)"))
        }

        dispatch.startAllTasks()

        XCTAssert(dispatch.numberOfConcurrentTasks == 3)
        XCTAssert(dispatch.taskAtIndex(0)?.status == .Downloading)
        XCTAssert(dispatch.taskAtIndex(1)?.status == .Downloading)
        XCTAssert(dispatch.taskAtIndex(2)?.status == .Downloading)

        dispatch.start(atIndex: 3)
        XCTAssert(dispatch.numberOfConcurrentTasks == 3)
        XCTAssert(dispatch.taskAtIndex(3)?.status == .Waiting)

        dispatch.pause(atIndex: 2)
        dispatch.start(atIndex: 3)
        XCTAssert(dispatch.numberOfConcurrentTasks == 3)
        XCTAssert(dispatch.taskAtIndex(3)?.status == .Downloading)

        let reader = DownloadManager.manager(databaseName)
        XCTAssert(reader.taskAtIndex(0)?.status == .Downloading)
        XCTAssert(reader.taskAtIndex(1)?.status == .Downloading)
        XCTAssert(reader.taskAtIndex(2)?.status == .Paused)
        XCTAssert(reader.taskAtIndex(3)?.status == .Downloading)
    }
}
