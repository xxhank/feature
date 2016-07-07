//
//  FeedCell.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/6.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

struct FeedCellViewModel {
    var title: String
    var brief: String
    var postImage: NSURL?
    var extraInfo: String
    var isFavorite: Bool
}

class FeedCell: UITableViewCell {
    @IBOutlet weak var postImage: AsyncLoadImageView!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var extraInfo: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!

    typealias ModifyFavoriteBlock = (cell: FeedCell) -> Void
    var modifyFavoriteBlock: ModifyFavoriteBlock?

    override func awakeFromNib() {
        favoriteButton.addTarget(self, action: #selector(FeedCell.favoriteButtonClicked(_:)), forControlEvents: .TouchUpInside)
    }
    var viewModel: FeedCellViewModel? {
        didSet {
            if let viewModel = viewModel {
                titleLabel.text = viewModel.title
                briefLabel.text = viewModel.brief
                extraInfo.text = viewModel.extraInfo
                postImage.async_image = viewModel.postImage
                let favoriteImage = UIImage(named: viewModel.isFavorite ? "已收藏" : "未收藏")
                favoriteButton.setImage(favoriteImage, forState: .Normal)
            }
        }
    }

    override func prepareForReuse() {
        // 重置影响较大属性
        postImage.async_image = nil
        // 重置会导致出错的属性
        modifyFavoriteBlock = nil
        // 其他属性,可以不重置
    }

    func favoriteButtonClicked(sender: AnyObject?) {
        guard var viewModel = viewModel else { return }
        guard let block = modifyFavoriteBlock else { return }
        // 更新数据属性
        viewModel.isFavorite = !viewModel.isFavorite

        // 更新按钮的状态
        let favoriteImage = UIImage(named: viewModel.isFavorite ? "已收藏" : "未收藏")
        favoriteButton.setImage(favoriteImage, forState: .Normal)

        // 通知外部
        block(cell: self)
    }
}
