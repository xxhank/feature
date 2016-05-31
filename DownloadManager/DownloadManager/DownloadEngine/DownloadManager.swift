//
//  DownloadManager.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/5/31.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit

public class DownloadTask {
    public var key: String = ""
}

public class DownloadManager: NSObject {
    class func manager(database: String) -> DownloadManager {
        return DownloadManager(database: database)
    }

    public var numberOfTasks: Int {
        return tasks.count
    }

    var tasks: [DownloadTask] = []

    init(database: String) {

    }

    public func append(task: DownloadTask, allowDuplicate: Bool = false) {
        if allowDuplicate || taskWithKey(task.key) == nil {
            tasks.append(task)
        }
    }

    public func remove(task: DownloadTask) {
        if let index = indexOfTask(task) {
            tasks.removeAtIndex(index)
        }
    }

    func indexOfTask(task: DownloadTask) -> Int? {
        return tasks.indexOf({ (task_) -> Bool in
            return task_ === task
        })
    }

    func indexOfTask(forKey key: String) -> Int? {
        return tasks.indexOf({ (task_) -> Bool in
            return task_.key == key
        })
    }

    public func taskWithKey(key: String) -> DownloadTask? {
        if let index = indexOfTask(forKey: key) {
            return tasks[index]
        }
        return nil
    }

    func taskAtIndex(index: Int) -> DownloadTask? {
        if index < tasks.count {
            return tasks[index]
        } else {
            return nil
        }
    }

}
