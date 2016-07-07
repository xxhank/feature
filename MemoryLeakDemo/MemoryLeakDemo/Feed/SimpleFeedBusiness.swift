//
//  SimpleFeedBusiness.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/6.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

enum SimpleFeedError: ErrorType {
    case InvalidIndex
    case InvalidToken
    case InvalidReponse
}

extension Request: SSCancelable {

}

class SimpleFeedBusiness: Business {
    static let URL = "http://rec.chaojishipin.com/sarrs/rec?app_id=732&appfrom=appstore&appid=0&appv=1.3.0&area=rec_0703&bd=iPhone&builder_number=simple_1&cid=2&city=CN_1_5_1&clientos=iPhone%20OS9.3.2&ctime=1467747906257&device=chaojishipin&ip=-&nt=wifi&os=iOS&osv=9.3.2&p=0&pl=1000010&pl1=0&pl2=01&resolution=667_375&scale=2&width=750&xh=iPhone%206s"
    var feeds: [Feed] = []

    func loadFeeds() -> BusinessTypes< [FeedCellViewModel]>.Task {
        return runTask({ [weak self](fulfill, reject) -> SSCancelable? in
            let urlString = "\(SimpleFeedBusiness.URL)&r=\(Int64(NSDate().timeIntervalSince1970*1000))"
            return Alamofire.request(.GET, urlString).responseJSON { [weak self](response) in
                guard let wself = self else { return }
                let result = response.result
                switch result {
                case .Failure(let error):
                    reject(error)
                case .Success(let jsonData):
                    guard let feedResponse = Mapper<FeedResponse>().map(jsonData)
                    where feedResponse.statusCode == "200" else {
                        reject(SimpleFeedError.InvalidReponse as NSError)
                        return
                    }

                    wself.feeds = feedResponse.feeds

                    let viewModels = self?.feeds.map({ (feed) in
                        return FeedCellViewModel(title: feed.title, brief: feed.brief, postImage: NSURL(string: feed.postImage), extraInfo: feed.tags, isFavorite: false)
                    })

                    fulfill(viewModels ?? [])
                }
            }
            #if false
                /// 模拟出错几率
                let error = false; // arc4random() % 100 > 50

                Dispatch.after_in_global(0.1, identifier: Dispatch.QueueIdentifier.USER_INTERACTIVE) { [weak self] in
                    if error {
                        reject(SimpleFeedError.InvalidToken as NSError)
                    } else {

                        for i in 0..<10 {
                            let feed = FeedModel()
                            feed.title = "title \(i)"
                            feed.brief = "brief \(i)"
                            feed.isFavorite = arc4random() % 99 > 70
                            self?.feeds.append(feed)
                        }

                        let viewModels = self?.feeds.map({ (feed) in
                            return FeedCellViewModel(title: feed.title, brief: feed.brief, postImage: NSURL(string: feed.postImage), isFavorite: feed.isFavorite)
                        })

                        fulfill(viewModels ?? [])
                    }
                }

                return nil
            #endif
        })
    }
    func toggleFavorite(index: Int) -> BusinessTypes<Bool>.Task {
        guard let feed = feeds[safe: index] else {
            return BusinessTypes<Bool>.Task(error: SimpleFeedError.InvalidIndex as NSError)
        }

        return runTask({ (fulfill, reject) -> SSCancelable? in
            /// 模拟出错几率
            let error = arc4random() % 100 > 50

            Dispatch.after_in_global(0.1, identifier: Dispatch.QueueIdentifier.USER_INTERACTIVE, block: {
                if error {
                    reject(SimpleFeedError.InvalidToken as NSError)
                } else {
                    // feed.isFavorite = !feed.isFavorite
                    fulfill(false)
                }
            })

            return nil
        })
    }
}