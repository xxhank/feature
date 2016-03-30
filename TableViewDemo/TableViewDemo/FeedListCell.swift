//
//  FeedListCell.swift
//  TableViewDemo
//
//  Created by wangchaojs02 on 16/3/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

struct FeedViewModel {
    var title: String
    var summary: String
}

protocol SupportViewModel {
    var viewModel: Any? { set get }
}
class FeedListCell: UITableViewCell, SupportViewModel {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!

    // MARK: - SupportViewModel
    var viewModel: Any? {
        didSet {
            guard let feedViewModel = viewModel as? FeedViewModel else { return }
            titleLabel.text = feedViewModel.title
            summaryLabel.text = feedViewModel.summary
        }
    }
}

// MARK: - Table Cycle
extension FeedListCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

// MARK: - IBAction
extension FeedListCell {
    @IBAction func unlike(sender: AnyObject) {
    }
}
