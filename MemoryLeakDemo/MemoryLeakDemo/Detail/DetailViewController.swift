//
//  DetailViewController.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/7.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import XCGLogger
import UITableView_FDTemplateLayoutCell

// MARK: - Protocol

// MARK: - Constant

// MARK: - Controller
class DetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var viewModels = [EpisodeCellViewModel]()
    var business = DetailBusiness()
    // MARK: Object Cycle
}

// MARK: - Override
extension DetailViewController {
    // MARK: Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let episodeHeaderNib = UINib(nibName: "EpisodeHeaderView", bundle: nil)
        tableView.registerNib(episodeHeaderNib, forHeaderFooterViewReuseIdentifier: "EpisodeHeaderView")

        business.loadEpisodes()
            .success { [weak self](viewModels) -> Void in
                guard let wself = self else { return }

                Dispatch.async_on_ui({
                    wself.viewModels = viewModels
                    wself.tableView.reloadData()
                })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = "EpisodeCell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(identifier) {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: identifier)
        }
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterViewWithIdentifier("EpisodeHeaderView")
    }
}
// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = "EpisodeCell"
        return tableView.fd_heightForCellWithIdentifier(identifier, configuration: { (cell) in
            if let episodeCell = cell as? EpisodeCell {
                episodeCell.viewModel = self.viewModels[safe: indexPath.row]
            }
        })
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        guard let episodeCell = cell as? EpisodeCell else { return }
        episodeCell.viewModel = viewModel
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        XCGLogger.info("\(viewModel)")
    }
}