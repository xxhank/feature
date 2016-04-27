//
//  SSLogger.swift
//  Storage
//
//  Created by wangchao9 on 16/4/23.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

func SSLogInfo(message: Any, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function) {
    print("<\((fileName as NSString).lastPathComponent):\(lineNumber) \(functionName)>Info: \(message)")
}

func SSLogWarning(message: Any, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function) {
    print("<\((fileName as NSString).lastPathComponent):\(lineNumber) \(functionName)>Warn: \(message)")
}

func SSLogError(message: Any, fileName: String = #file, lineNumber: Int = #line, functionName: String = #function) {
    print("<\((fileName as NSString).lastPathComponent):\(lineNumber) \(functionName)>Error: \(message)")
}
