//
//  SSPath.swift
//  TheSarrs
//
//  Created by wangchao9 on 16/3/4.
//  Copyright © 2016年 leso. All rights reserved.
//

import UIKit

// MAKR: - Path
public extension String {
    public func joinPath(path: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(path)
    }

    public func joinExt(pathExtension: String) -> String {
        return (self as NSString).stringByAppendingPathExtension(pathExtension)!
    }
    public func filename() -> String {
        return (self as NSString).lastPathComponent
    }

    public func directory() -> String {
        return (self as NSString).stringByDeletingLastPathComponent
    }
}

public class SSPath {
    public class func document() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    public class func cache() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        return paths[0]
    }
    public class func library() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        return paths[0]
    }
    public class func temp() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        return paths[0]
        // let paths = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        // return paths[0]
        return NSTemporaryDirectory()
    }

    public class func downloadFolder() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return (paths[0] as NSString).stringByAppendingPathComponent("downloads")
    }

    public class func bundle(bundle: NSBundle = NSBundle.mainBundle()) -> String {
        return bundle.bundlePath
    }
    public class func pathForResource(resource: String, bundle: NSBundle = NSBundle.mainBundle()) -> String? {
        let path = bundle.pathForResource(resource, ofType: nil)
        if path == nil {
            SSLogError("\(resource) not exist in \(bundle)")
        }
        return path
    }
    /**
     check if given path exists

     - parameter path: file or directory

     - returns: (exist, isDirectory)
     */
    public class func exists(path: String) -> (Bool, Bool) {
        var isDirectory: ObjCBool = false

        let exist = NSFileManager.defaultManager().fileExistsAtPath(path, isDirectory: &isDirectory)
        return (exist, isDirectory.boolValue)
    }

    public class func disableBackupToCloud(path: String) -> Bool {
        let URL = NSURL(fileURLWithPath: path)

        let success: Bool
        do {
            try URL.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
            success = true
        } catch let error {
            success = false
            SSLogInfo("Error excluding \((path as NSString).lastPathComponent) \(error)")
        }
        return success
    }

    public class func rm(path: String) {
        var isDirectory: ObjCBool = true
        let fileManager = NSFileManager.defaultManager()
        let exist = fileManager.fileExistsAtPath(path, isDirectory: &isDirectory)
        if exist {
            do {
                try fileManager.removeItemAtPath(path)
            } catch(let error) {
                SSLogError("\(error)")
            }
        }
    }

    /**
     在指定位置创建一个文件

     - parameter path: 文件位置
     */
    public class func touch(path: String) {
        SSPath.rm(path)
        let fileManager = NSFileManager.defaultManager()
        let success = fileManager.createFileAtPath(path, contents: nil, attributes: nil)
        if !success {
            SSLogInfo("create \(path) failed!")
        }
    }

    public class func mkdir(path: String, backupToiCloud: Bool = false, isFilePath: Bool = true) -> Bool {
        let directory = isFilePath ? path.directory() : path
        var isDirectory: ObjCBool = true

        let fileManager = NSFileManager.defaultManager()
        let exist = fileManager.fileExistsAtPath(directory, isDirectory: &isDirectory)

        if exist && !isDirectory {
            SSLogError("\(directory) exist and not a dir")
            return false
        }

        var attributes = [String: AnyObject]()
        if (!backupToiCloud) {
            attributes[NSURLIsExcludedFromBackupKey] = true
        }
        if !exist {
            do {
                try fileManager.createDirectoryAtPath(directory, withIntermediateDirectories: true, attributes: attributes)
            } catch(let error) {
                SSLogError("\(error)")
                return false
            }
        }

        return true
    }
    public class func folderSize(path: String) -> UInt64 {
        let manager = NSFileManager.defaultManager()
        guard manager.fileExistsAtPath(path) else { return 0 }
        var size: UInt64 = 0
        for item in manager.subpathsAtPath(path)! {
            let full = path.joinPath(item)
//            size += SSPath.folderSize(full)
            size += SSPath.fileSize(full)
        }
        return size
    }

    public class func fileSize(path: String) -> UInt64 {
        let manager = NSFileManager.defaultManager()
        guard manager.fileExistsAtPath(path) else { return 0 }

        do {
            let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(path)
            if let fileSize = fileAttributes[NSFileSize] {
                return (fileSize as! NSNumber).unsignedLongLongValue
            } else {
                SSLogInfo("Failed to get a size attribute from path: \(path)")
            }
        } catch {
            SSLogInfo("Error: \(error)")
        }

        return 0
    }

}

extension NSFileManager {
    public func fileSizeAtPath(path: String) -> Int64 {
        do {
            let fileAttributes = try attributesOfItemAtPath(path)
            let fileSizeNumber = fileAttributes[NSFileSize]
            let fileSize = fileSizeNumber?.longLongValue
            return fileSize!
        } catch {
            SSLogWarning("error reading filesize, NSFileManager extension fileSizeAtPath")
            return 0
        }
    }

    public func folderSizeAtPath(path: String) -> Int64 {
        var size: Int64 = 0
        do {
            let files = try subpathsOfDirectoryAtPath(path)
            for var i = 0; i < files.count; ++i {
                size += fileSizeAtPath((path as NSString).stringByAppendingPathComponent(files[i]) as String)
            }
        } catch {
            SSLogWarning("error reading directory, NSFileManager extension folderSizeAtPath")
        }
        return size
    }
}