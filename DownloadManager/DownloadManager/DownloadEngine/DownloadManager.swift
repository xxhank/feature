//
//  DownloadManager.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/5/31.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit
import Alamofire

public enum DownloadTaskStatus: String {
    case Waiting = "waiting"
    case Paused = "pause"
    case Downloading = "downloading"
    case Finished = "finished"
    case Failed = "failed"

    public init(stringValue: String) {
        self = DownloadTaskStatus(rawValue: stringValue) ?? .Waiting
    }
}

protocol DownloadTaskDelegate: class {
    func taskFinished(task: DownloadTask, finished: Bool)
    func downloader() -> Alamofire.Manager
}

public class DownloadTask {
    public var key: String = ""
    public var url: String = ""
    public var status = DownloadTaskStatus.Waiting {
        didSet {
            updateDB()
            if let obsever = statusObsever {
                obsever(status: status)
            }
        }
    }

    public var progress: Float = 0.0 {
        didSet {
            if let obsever = progressObserver {
                obsever(progress: progress)
            }
        }
    }

    public var total: Int64 = 0 {
        didSet {
            if let obsever = progressObserver {
                obsever(progress: progress)
            }
        }
    }

    public var received: Int64 = 0 {
        didSet {
            if let obsever = progressObserver {
                obsever(progress: progress)
            }
        }
    }

    public var statusObsever: ((status: DownloadTaskStatus) -> Void)?
    public var progressObserver: ((progress: Float) -> Void)?
    public var totalObserver: ((total: Int) -> Void)?
    public var receivedObserver: ((total: Int) -> Void)?

    lazy var destinationPath: String = {
        let fileName = "downloads/\(self.key)"
        let path = SSPath.document().joinPath(fileName)
        SSPath.mkdir(path, isFilePath: true)
        return path
    }()

    lazy var resumeDataPath: String = {
        return self.destinationPath.joinExt("plist")
    }()

    weak var delegate: DownloadTaskDelegate?
    var request: Request?

    convenience public init() {
        self.init(key: "", url: "")
    }

    public required init(key: String, url: String) {
        self.key = key
        self.url = url
        self.status = .Waiting
        self.progress = 0.0
    }

    public required init?(with dict: [String: Any]) {
        key = dict.ss_valueForKey("key", defaultValue: "")
        url = dict.ss_valueForKey("url", defaultValue: "")
        status = DownloadTaskStatus(stringValue: dict.ss_valueForKey("status", defaultValue: ""))
        progress = dict.ss_valueForKey("progress", defaultValue: 0.0)
        if url.isEmpty || NSURL(string: url) == nil {
            return nil
        }
    }

    func downloadFileDestination() -> Request.DownloadFileDestination {
        return { [weak self](temp, response) -> NSURL in
            guard let wself = self else {
                assert(false, "")
                return NSURL(fileURLWithPath: SSPath.document())
            }
            return NSURL(fileURLWithPath: wself.destinationPath)
        }
    }

    func start(withDelegate delegate: DownloadTaskDelegate?) {
        self.delegate = delegate
        self.status = .Downloading

        if (request != nil) {
            request?.resume()
            return
        }

        if let downloader = delegate?.downloader() {
            request = downloader.download(.GET, self.url, destination: downloadFileDestination())
                .progress({ [weak self](_, all, total) in
                    self?.received = (all);
                    self?.total = (total)
                    self?.progress = Float(all) / Float(total)
            }).response(completionHandler: { [weak self](request, response, data, error) in
                    guard let wself = self else { return }
                    if (error != nil) {
                        if error?.code == NSURLErrorCancelled {
                            SSLogInfo("canceled")
                            if let resumeData = data {
                                resumeData.writeToFile(wself.resumeDataPath, atomically: true)
                            }
                            wself.updateDB()
                        } else {
                            SSLogInfo("\(error)")
                        }
                        wself.status = .Failed
                    } else {
                        wself.status = .Finished
                    }
                    wself.delegate?.taskFinished(wself, finished: error == nil)
            })
        }
    }

    func pause() {
        self.delegate = nil
        self.status = .Paused
        request?.suspend()
        updateDB()
    }
}

// MARK: - SupportDatabasePersistent
extension DownloadTask: SupportDatabasePersistent {
    public static func tableName() -> String {
        return "download"
    }
    public static func databaseName() -> String {
        return DownloadManager.database
    }
    public static func columns() -> [(String, SQLiteDataType, SQLiteCapacity, [SQLiteConstraint])] {
        return [
            ("key", SQLiteDataType.TEXT, SQLiteCapacity.None, [SQLiteConstraint.PRIMARY_KEY]),
            ("url", SQLiteDataType.TEXT, SQLiteCapacity.None, []),
            ("status", SQLiteDataType.TEXT, SQLiteCapacity.None, []),
            ("progress", SQLiteDataType.Float, SQLiteCapacity.None, []),
            ("total", SQLiteDataType.INTEGER, SQLiteCapacity.None, []),
            ("received", SQLiteDataType.INTEGER, SQLiteCapacity.None, [])
        ]
    }

    public func valueForColumn(column: String) -> Any? {
        switch column {
        case "key": return key
        case "url": return url
        case "status": return status.rawValue
        case "progress": return progress
        case "total": return total
        case "received": return received
        default: return nil
        }
    }

    public func updateDB() {
        self.db_update(["total", "received", "progress", "status"])
    }
}

public class DownloadManager: NSObject {
    static var database = "download.db"
    class func manager(database: String) -> DownloadManager {
        return DownloadManager(database: database)
    }

    let backgroundTaskIdentifier = "com.xxx.download.background"
    lazy var worker: Alamofire.Manager = {
        let configuration =
            NSURLSessionConfiguration
            .backgroundSessionConfigurationWithIdentifier(self.backgroundTaskIdentifier)
        return Manager(configuration: configuration) }()

    /// 所有任务数量
    public var numberOfTasks: Int {
        return tasks.count
    }

    /// 并发任务数量
    public var numberOfConcurrentTasks: Int = 0
    /// 最大并发数量
    public var MaxNumberOfConcurrentTasks = 3
    /// 任务列表
    var tasks: [DownloadTask] = []
    /// 正在下载的任务
    var runingTasks: [String: DownloadTask] = [:]

    init(database: String = "download.db") {
        DownloadManager.database = database
        tasks = DownloadTask.db_select()
    }
}

// MARK: - dispatch task
extension DownloadManager: DownloadTaskDelegate {
    public func startAllTasks() {
        for (index, _) in tasks.enumerate() {
            if numberOfConcurrentTasks >= MaxNumberOfConcurrentTasks {
                break;
            }
            start(atIndex: index)
        }
    }

    public func start(atIndex index: Int) {
        if let task = taskAtIndex(index) where task.status != .Finished {
            if numberOfConcurrentTasks < MaxNumberOfConcurrentTasks {
                numberOfConcurrentTasks += 1
                task.start(withDelegate: self)
                runingTasks[task.key] = task
            } else {
                SSLogInfo("too many concurrent task runing")
            }
        }
    }

    public func pause(atIndex index: Int) {
        if let task = taskAtIndex(index) where task.status == .Downloading {
            if numberOfConcurrentTasks > 0 {
                numberOfConcurrentTasks -= 1
            }
            task.pause()
        }
    }

    // MARK: DownloadTaskDelegate
    func taskFinished(task: DownloadTask, finished: Bool) {
        if numberOfConcurrentTasks > 0 {
            numberOfConcurrentTasks -= 1
        }
        runingTasks.removeValueForKey(task.key)
        startAllTasks()
    }

    func downloader() -> Alamofire.Manager {
        return self.worker
    }
}

// MARK: - queue manager
extension DownloadManager {
    public func append(task: DownloadTask, allowDuplicate: Bool = false) {
        if allowDuplicate || taskWithKey(task.key) == nil {
            tasks.append(task)
            task.db_insert()
        }
    }

    public func remove(task: DownloadTask) {
        if let index = indexOfTask(task) {
            tasks.removeAtIndex(index)
            task.db_delete()
        }
    }

    public func removeAtIndex(index: Int) {
        if index < tasks.count {
            tasks.removeAtIndex(index)
            let task = tasks[index]
            task.db_delete()
        }
    }

    public func removeAll() {
        tasks.removeAll()
        DownloadTask.db_clear()
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

    public func taskAtIndex(index: Int) -> DownloadTask? {
        if index < tasks.count {
            return tasks[index]
        } else {
            return nil
        }
    }
}
