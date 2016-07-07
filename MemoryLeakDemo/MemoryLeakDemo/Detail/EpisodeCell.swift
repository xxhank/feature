//
//  EpisodeCell.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/7.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

class EpisodeBlockCellViewModel {
    var playing = false
    var indexText = "1"
}

class EpisodeBlockCell: UICollectionViewCell {
    @IBOutlet weak var playingMark: UIImageView!
    @IBOutlet weak var indexLabel: UILabel!

    var viewModel: EpisodeBlockCellViewModel? {
        didSet {
            playingMark.hidden = !(viewModel?.playing ?? false)
            indexLabel.text = viewModel?.indexText
        }
    }
}

class EpisodeCellViewModel {
    var episodeBlockCellViewModels = [EpisodeBlockCellViewModel]()
    var playingEpisodeIndex = 0
}

class EpisodeCell: UITableViewCell {
    @IBOutlet weak var episodesView: UICollectionView!

    var viewModel: EpisodeCellViewModel? {
        didSet {
            if fd_isTemplateLayoutCell {
                return
            }

            if let viewModel = viewModel {
                episodesView.reloadData()
                let selectIndexPath = NSIndexPath(forItem: viewModel.playingEpisodeIndex, inSection: 0)
                episodesView.selectItemAtIndexPath(selectIndexPath, animated: false, scrollPosition: .Left)
            }
        }
    }
}

extension EpisodeCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        episodesView.delegate = self
        episodesView.dataSource = self
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
        return CGSize(width: self.bounds.width / 6.0, height: self.bounds.height)
    }
}