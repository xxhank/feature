//
//  DetailBusiness.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/7.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

class DetailBusiness: Business {
    func loadEpisodes() -> BusinessTypes<[EpisodeCellViewModel]>.Task {
        return runTask({ [weak self](fulfill, reject) -> SSCancelable? in
            Dispatch.after_in_global(0.1, identifier: Dispatch.QueueIdentifier.USER_INTERACTIVE) { [weak self] in

                var episodeBlockCellViewModels = [EpisodeBlockCellViewModel]()
                for i in 0 ..< 110 {
                    let episodeBlockCellViewModel = EpisodeBlockCellViewModel()
                    episodeBlockCellViewModel.indexText = "\(i+1)"
                    episodeBlockCellViewModels.append(episodeBlockCellViewModel)
                }

                let episodeViewModel = EpisodeCellViewModel()
                episodeViewModel.episodeBlockCellViewModels = episodeBlockCellViewModels
                episodeViewModel.playingEpisodeIndex = 0
                fulfill([episodeViewModel])
            }
            return nil
        })
    }
}
