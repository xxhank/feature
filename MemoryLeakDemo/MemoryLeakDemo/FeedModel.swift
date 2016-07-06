//
//  FeedModel.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/6.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import Foundation
import ObjectMapper
class MLDResponse {
    var statusMessage = ""
    var statusCode = ""
}

class FeedResponse: MLDResponse, Mappable {
    var feeds = [FeedModel]()

    required init?(_ map: Map) {

    }
    func mapping(map: Map) -> () {
        statusMessage <- map["message"]
        statusCode <- map["status"]
        feeds <- map["items"]
    }
}

class FeedModel: Mappable {
    var title = ""
    var subTitle = ""
    var brief = ""
    var postImage = ""
    var tags = ""
    var playCount = ""
    var mark = ""
    var source = ""
    var catagory = ""

    var video = [Video]()

    required init?(_ map: Map) {

    }

    func mapping(map: Map) -> () {
        title <- map["title"]
        subTitle <- map["sub_title"]
        brief <- map["description"]
        postImage <- map["image"]
        tags <- map["tags"]
        playCount <- map[playCount]
        mark <- map["mark"]
        source <- map["source"]
        catagory <- map["catagory_name"]
    }
}

class Video {
    var title = ""
    var id = ""
    var url = ""
}