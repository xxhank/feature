//
//  EpisodeCell.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/7.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import XCGLogger

class EpisodeBlockCellViewModel {
    var playing = false
    var indexText = "1"
}

class EpisodeBlockCell: UICollectionViewCell {
    @IBOutlet weak var playingMark: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    var viewModel: EpisodeBlockCellViewModel? {
        didSet {
            playingMark.hidden = !(viewModel?.playing ?? false)
            indexLabel.text = viewModel?.indexText
        }
    }

    static func backgroundImage(size: CGSize) -> UIImage {
        struct Static {
            static var predicate: dispatch_once_t = 0
            static var instance: UIImage? = nil
        }
        dispatch_once(&Static.predicate) {
            Static.instance = UIImage.strokeImage(UIColor.whiteColor(), size: size, borderColor: UIColor.redColor(), borderWidth: 1)
        }
        return Static.instance!
    }
}

class EpisodeCellViewModel {
    var episodeBlockCellViewModels = [EpisodeBlockCellViewModel]()
    var playingEpisodeIndex = 0
}

class EpisodeCell: UITableViewCell {
    @IBOutlet weak var episodesView: UICollectionView!
    @IBOutlet weak var episodesViewHeightConstraint: NSLayoutConstraint!

    var viewModel: EpisodeCellViewModel? {
        didSet {
            if let episodesViewHeightConstraint = episodesViewHeightConstraint {
                let numberOfRows = ((viewModel?.episodeBlockCellViewModels.count ?? 0) + 5) / 6
                episodesViewHeightConstraint.constant = CGFloat(numberOfRows) * 40
            }

            if fd_isTemplateLayoutCell {
                return
            }

            if let viewModel = viewModel {
                episodesView.reloadData()
                if viewModel.playingEpisodeIndex > 0
                && viewModel.playingEpisodeIndex < viewModel.episodeBlockCellViewModels.count {
                    let selectIndexPath = NSIndexPath(forItem: viewModel.playingEpisodeIndex, inSection: 0)
                    episodesView.selectItemAtIndexPath(selectIndexPath, animated: false, scrollPosition: .Left)
                }
            }
        }
    }

    lazy var blockCellSize: CGSize = {
        return CGSize(width: self.bounds.width / 6.1, height: 40)
        let scale = UIScreen.mainScreen().scale
        let dobuleCellWidth = CGFloat(Int((self.bounds.width) * scale / 6))
        let cellWidth = dobuleCellWidth / scale
        return CGSize(width: cellWidth, height: 40)
    }()
}

extension EpisodeCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        episodesView.delegate = self
        episodesView.dataSource = self
        episodesView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension EpisodeCell: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.episodeBlockCellViewModels.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier("EpisodeBlockCell", forIndexPath: indexPath)
    }
}

extension EpisodeCell: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? EpisodeBlockCell,
            let viewModel = viewModel,
            let blockViewModel = viewModel.episodeBlockCellViewModels[safe: indexPath.row] else {
                return
        }
        blockViewModel.playing = (indexPath.row == viewModel.playingEpisodeIndex)
        cell.viewModel = blockViewModel
        cell.backgroundImageView.image = EpisodeBlockCell.backgroundImage(CGSize(width: blockCellSize.width, height: blockCellSize.height))
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = viewModel,
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
        guard let viewModel = viewModel,
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