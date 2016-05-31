//
//  SSLogger.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/24.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class SSLogger: NSObject {
}

func SSLogInfo(message: AnyObject, file: String = #file, line: Int = #line, function: String = #function) {
    print("I \((file as NSString).lastPathComponent ):\(line) \(function)> \(message)")
}

func SSLogWarning(message: AnyObject, file: String = #file, line: Int = #line, function: String = #function) {
    print("W \((file as NSString).lastPathComponent):\(line) \(function)> \(message)")
}
func SSLogError(message: AnyObject, file: String = #file, line: Int = #line, function: String = #function) {
    print("E \((file as NSString).lastPathComponent):\(line) \(function)> \(message)")
}