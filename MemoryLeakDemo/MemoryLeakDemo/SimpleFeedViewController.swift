//
//  SimpleFeedViewController.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/1.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import XCGLogger
import UITableView_FDTemplateLayoutCell

class SimpleFeedViewController: UIViewController {
    var viewModels = [FeedCellViewModel]()
    var business = SimpleFeedBusiness()
    @IBOutlet weak var tableView: UITableView!
}

// MARK: -
extension SimpleFeedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParentViewController() {
            business.loadFeeds().success({ [weak self](viewModels) -> Void in
                guard let wself = self else { return }
                wself.viewModels.appendContentsOf(viewModels)

                Dispatch.async_on_ui({
                    wself.tableView.reloadData()
                })
            })
        }
    }
}

// MARK: -
extension SimpleFeedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "FeedCell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
    }
}

extension SimpleFeedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = "FeedCell"
        return tableView.fd_heightForCellWithIdentifier(identifier, configuration: { (cell) in
            if let feedCell = cell as? FeedCell {
                feedCell.viewModel = self.viewModels[safe: indexPath.row]
            }
        })
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        guard let feedCell = cell as? FeedCell else { return }
        feedCell.viewModel = viewModel

        // 处理函数无法知道是哪个cell中的按钮被点击
        // feedCell.favoriteButton.addTarget(self, action: #selector(SimpleFeedViewController.favoriteButtonClicked(_:)), forControlEvents: .TouchUpInside)

        feedCell.modifyFavoriteBlock = { [weak self](cell) in
            self?.toggleFavorite(cell)
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        XCGLogger.info("\(viewModel)")
    }
}

extension SimpleFeedViewController {
    // 需要额外的信息定位是哪个cell
    func favoriteButtonClicked(sender: AnyObject?) {

    }

    func toggleFavorite(cell: FeedCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        // guard let viewModel = viewModels[safe: indexPath.row] else { return }
    }
}
