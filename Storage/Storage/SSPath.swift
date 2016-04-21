//
//  SSPath.swift
//  Storage
//
//  Created by wangchaojs02 on 16/4/19.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation

public class SSPath {
    public static var document: String {
        return NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0];
    }
}
