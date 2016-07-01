//
//  SimpleFeedViewController.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/1.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

class AsyncLoadImageView: UIImageView {
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override init(image: UIImage?) {
        super.init(image: image)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var async_image: NSURL?
}

struct FeedCellViewModel {
    var title: String
    var brief: String
    var postImage: NSURL?
    var isFavorite: Bool
}

class FeedCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var briefLabel: UILabel!
    @IBOutlet weak var postImage: AsyncLoadImageView!
    @IBOutlet weak var favoriteButton: UIButton!

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

class FeedModel {
    var title: String = ""
    var brief: String = ""
    var postImage: String = ""
    var isFavorite: Bool = false
}

enum SimpleFeedError: ErrorType {
    case InvalidIndex
    case InvalidToken
}
class SimpleFeedBusiness: Business {
    var feeds: [FeedModel] = []

    func loadFeeds() -> BusinessTypes< [FeedCellViewModel]>.Task {
        return runTask({ [weak self](fulfill, reject) -> SSCancelable? in
            /// 模拟出错几率
            let error = arc4random() % 100 > 50

            Dispatch.after_in_global(0.1, identifier: Dispatch.QueueIdentifier.USER_INTERACTIVE) { [weak self] in
                if error {
                    reject(SimpleFeedError.InvalidToken as NSError)
                } else {

                    for i in 0..<10 {
                        let feed = FeedModel()
                        feed.title = "title \(i)"
                        feed.brief = "brief \(i)"
                        feed.isFavorite = arc4random() % 99 > 70
                        self?.feeds.append(feed)
                    }

                    let viewModels = self?.feeds.map({ (feed) in
                        return FeedCellViewModel(title: feed.title, brief: feed.brief, postImage: NSURL(string: feed.postImage), isFavorite: feed.isFavorite)
                    })

                    fulfill(viewModels ?? [])
                }
            }

            return nil
        })
    }
    func toggleFavorite(index: Int) -> BusinessTypes<Bool>.Task {
        guard let feed = feeds[safe: index] else {
            return BusinessTypes<Bool>.Task(error: SimpleFeedError.InvalidIndex as NSError)
        }

        return runTask({ (fulfill, reject) -> SSCancelable? in
            /// 模拟出错几率
            let error = arc4random() % 100 > 50

            Dispatch.after_in_global(0.1, identifier: Dispatch.QueueIdentifier.USER_INTERACTIVE, block: {
                if error {
                    reject(SimpleFeedError.InvalidToken as NSError)
                } else {
                    feed.isFavorite = !feed.isFavorite
                    fulfill(feed.isFavorite)
                }
            })

            return nil
        })
    }
}
class SimpleFeedViewController: UIViewController {
    var viewModels = [FeedCellViewModel]()
    @IBOutlet weak var tableView: UITableView!
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
        print("\(viewModel)")
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
