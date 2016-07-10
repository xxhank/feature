//
//  EpisodePickViewController.swift
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
class EpisodePickSectionViewModel {
    var title = "1-60"
    var rows = [EpisodeCellViewModel]()
}

// MARK: - Controller
class EpisodePickViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var episodeTopConstraint: NSLayoutConstraint!

    var completion: PickCompletion?
    var sectionViewModels = [EpisodePickSectionViewModel]()

    static let numberOfRowsInSection = 10
    static let numberOfCellsInRow = 6
    static let numberOfCellsInSection = EpisodePickViewController.numberOfRowsInSection * EpisodePickViewController.numberOfCellsInRow
    static let heightOfTableViewTop: CGFloat = 200

    // MARK: Object Cycle
}

// MARK: - Interface
struct EpisodePickParameters: PickParameters {
    var episodes: [EpisodeBlockCellViewModel]
    var selected: Int
}

// MARK: - Interface
extension EpisodePickViewController: SupportPick {
    class func pickViewController(hostController: UIViewController) -> SupportPick? {
        return hostController.storyboard?.instantiateViewControllerWithIdentifier("EpisodePickViewController") as?SupportPick
    }
    static var topOffset: CGFloat { return EpisodePickViewController.heightOfTableViewTop }

    var topConstraint: NSLayoutConstraint { return episodeTopConstraint }

    func prepare(parameters: PickParameters?) {
        guard let episodePickParameters = parameters as? EpisodePickParameters else {
            return
        }

        let episodes = episodePickParameters.episodes

        var episodePickSectionViewModels = [EpisodePickSectionViewModel]()
        var episodePickSectionViewModel: EpisodePickSectionViewModel!
        for (index, episode) in episodes.enumerate() {
            let indexInSection = index % EpisodePickViewController.numberOfCellsInSection
            if indexInSection == 0 {
                if episodePickSectionViewModel != nil {
                    episodePickSectionViewModels.append(episodePickSectionViewModel!)
                }
                episodePickSectionViewModel = EpisodePickSectionViewModel()
                episodePickSectionViewModel?.title = "\(index+1)-\(index+EpisodePickViewController.numberOfCellsInSection+1)"
            }

            let rowIndex = indexInSection / EpisodePickViewController.numberOfCellsInRow
            var row: EpisodeCellViewModel! = episodePickSectionViewModel?.rows[safe: rowIndex]
            if row == nil {
                row = EpisodeCellViewModel()
                episodePickSectionViewModel.rows.append(row)
            }
            row.playingEpisodeIndex = -1
            row.episodeBlockCellViewModels.append(episode)
        }

        if episodePickSectionViewModel != nil {
            episodePickSectionViewModels.append(episodePickSectionViewModel!)
        }

        sectionViewModels = episodePickSectionViewModels
    }
}

// MARK: - Override
extension EpisodePickViewController {
    // MARK: Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let episodeHeaderNib = UINib(nibName: "EpisodeHeaderView", bundle: nil)
        tableView.registerNib(episodeHeaderNib, forHeaderFooterViewReuseIdentifier: "EpisodeHeaderView")
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Actions
extension EpisodePickViewController {
    @IBAction func dismissSelf(sender: AnyObject) {
        completion?(result: nil)
    }
}

// MARK: - UITableViewDataSource
extension EpisodePickViewController: UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionViewModels.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionViewModels = sectionViewModels[safe: section] else { return 0 }
        return sectionViewModels.rows.count
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
extension EpisodePickViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let identifier = "EpisodeCell"
        return tableView.fd_heightForCellWithIdentifier(identifier, configuration: { (cell) in
            if let episodeCell = cell as? EpisodeCell {
                episodeCell.viewModel = self.sectionViewModels[safe: indexPath.section]?.rows[safe: indexPath.row]
            }
        })
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard let sectionViewModels = sectionViewModels[safe: indexPath.section] else { return }
        guard let episodeCell = cell as? EpisodeCell else { return }
        episodeCell.viewModel = sectionViewModels.rows[safe: indexPath.row]
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let episodeHeader = view as? EpisodeHeaderView else { return }
        episodeHeader.contentView.backgroundColor = UIColor.darkGrayColor()
        episodeHeader.viewMoreEpisodesBlock = nil
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let sectionViewModels = sectionViewModels[safe: indexPath.section] else { return }
        XCGLogger.info("\(sectionViewModels)")
        // let index = indexPath.section * 60 + indexPath.row * 6
    }
}