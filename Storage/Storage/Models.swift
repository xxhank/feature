//
//  Models.swift
//  Storage
//
//  Created by wangchao9 on 16/4/23.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import Foundation

enum DogColor: Int {
    case Black = 0
    case White = 1
    case Green = 2
}

enum DogColorValue: Int {
    case BlackValue
    case WhiteValue
    case GreenValue
}

struct Dog {
    var NO: Int
    var name: String
    var color: DogColor
    var owner: String?
}
struct Person {
    var NO: Int
    var name: String
    var age: Int64
    var addr: String
    var dogs: [Dog]
}

class Soical {
    var name: String
    var addr: String
    var members: [Person]

    init(name: String, addr: String, members: [Person]) {
        self.name = name
        self.addr = addr
        self.members = members
    }
}
