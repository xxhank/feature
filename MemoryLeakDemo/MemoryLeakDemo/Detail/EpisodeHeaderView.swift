//
//  EpisodeHeaderView.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/7.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

// MARK: - ActionBlock
extension UITableViewHeaderFooterView {
    typealias ActionBlock = (view: UITableViewHeaderFooterView, sender: AnyObject) -> Void
}

class EpisodeHeaderView: UITableViewHeaderFooterView {
    var viewMoreEpisodesBlock: ActionBlock?

    override var contentView: UIView {
        return self.subviews[0]
    }

    @IBAction func viewMoreEpisodes(sender: AnyObject) {
        viewMoreEpisodesBlock?(view: self, sender: sender)
    }
}
