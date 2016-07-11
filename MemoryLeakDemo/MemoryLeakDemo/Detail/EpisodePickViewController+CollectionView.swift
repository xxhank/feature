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

// MARK: - Controller

class CollectionBaseEpisodePickSectionViewModel: EpisodeCellViewModel {
    var title = "1-60"
}

class CollectionBaseEpisodePickViewController: UIViewController {
    @IBOutlet weak var episodesView: UICollectionView!
    @IBOutlet weak var episodeTopConstraint: NSLayoutConstraint!

    var completion: PickCompletion?
    var sectionViewModels = [CollectionBaseEpisodePickSectionViewModel]()
    lazy var blockCellSize: CGSize = {
        return CGSize(width: self.view.bounds.width / 6.1, height: 40)
    }()
}

// MARK: - Interface
extension CollectionBaseEpisodePickViewController: SupportPick {
    class func pickViewController(hostController: UIViewController) -> SupportPick? {
        return hostController.storyboard?.instantiateViewControllerWithIdentifier("CollectionBaseEpisodePickViewController") as?SupportPick
    }
    static var topOffset: CGFloat { return EpisodePickViewController.heightOfTableViewTop }

    var topConstraint: NSLayoutConstraint { return episodeTopConstraint }

    func prepare(parameters: PickParameters?) {
        guard let episodePickParameters = parameters as? EpisodePickParameters else {
            return
        }

        let episodes = episodePickParameters.episodes

        var episodePickSectionViewModels = [CollectionBaseEpisodePickSectionViewModel]()
        var episodePickSectionViewModel: CollectionBaseEpisodePickSectionViewModel!
        for (index, episode) in episodes.enumerate() {
            let indexInSection = index % EpisodePickViewController.numberOfCellsInSection
            if indexInSection == 0 {
                if episodePickSectionViewModel != nil {
                    episodePickSectionViewModels.append(episodePickSectionViewModel!)
                }
                episodePickSectionViewModel = CollectionBaseEpisodePickSectionViewModel()
                episodePickSectionViewModel?.title = "\(index+1)-\(index+60+1)"
            }

            episodePickSectionViewModel.playingEpisodeIndex = -1
            episodePickSectionViewModel.episodeBlockCellViewModels.append(episode)
        }

        if episodePickSectionViewModel != nil {
            episodePickSectionViewModels.append(episodePickSectionViewModel!)
        }

        self.sectionViewModels = episodePickSectionViewModels
    }
}

// MARK: - Override
extension CollectionBaseEpisodePickViewController {
    // MARK: Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        episodesView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - Actions
extension CollectionBaseEpisodePickViewController {
    @IBAction func dismissSelf(sender: AnyObject) {
        completion?(result: nil)
    }
}

extension CollectionBaseEpisodePickViewController: UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return sectionViewModels.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = sectionViewModels[safe: section] else { return 0 }
        return viewModel.episodeBlockCellViewModels.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("EpisodeBlockCell", forIndexPath: indexPath)
    }

    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "EpisodeHeaderView", forIndexPath: indexPath)
    }
}

extension CollectionBaseEpisodePickViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? EpisodeBlockCell,
            let viewModel = sectionViewModels[safe: indexPath.section],
            let blockViewModel = viewModel.episodeBlockCellViewModels[safe: indexPath.row] else {
                return
        }
        blockViewModel.playing = (indexPath.row == viewModel.playingEpisodeIndex)
        cell.viewModel = blockViewModel
        cell.backgroundImageView.image = EpisodeBlockCell.backgroundImage(CGSize(width: blockCellSize.width, height: blockCellSize.height))
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = sectionViewModels[safe: indexPath.section],
            let blockViewModel = viewModel.episodeBlockCellViewModels[safe: indexPath.row] else {
                return
        }

        viewModel.playingEpisodeIndex = indexPath.row
        blockViewModel.playing = true
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? EpisodeBlockCell else { return }
        cell.viewModel = blockViewModel

        let cellFrame = cell.frame
        if indexPath.item > 0 {
            let before = cellFrame.offsetBy(dx: -cellFrame.width, dy: 0)
            collectionView.scrollRectToVisible(before, animated: true)
        }

        if indexPath.item < viewModel.episodeBlockCellViewModels.count - 1 {
            let after = cellFrame.offsetBy(dx: cellFrame.width, dy: 0)
            collectionView.scrollRectToVisible(after, animated: true)
        }
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = sectionViewModels[safe: indexPath.section],
            let blockViewModel = viewModel.episodeBlockCellViewModels[safe: indexPath.row] else {
                return
        }

        blockViewModel.playing = false
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? EpisodeBlockCell
        cell?.viewModel = blockViewModel
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return blockCellSize
    }
}