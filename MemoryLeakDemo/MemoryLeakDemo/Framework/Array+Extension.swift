//
//  Array+Extension.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/1.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import Foundation
extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index]: nil
    }
}