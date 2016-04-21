//
//  GClass.swift
//  GenericAndExtension
//
//  Created by wangchao9 on 16/4/12.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit

class GClass<T>: NSObject {
    var value: T
    init(value: T) {
        self.value = value
    }
}

extension GClass<T>: UITableViewDelegate {
    func hello() {
    }
}
