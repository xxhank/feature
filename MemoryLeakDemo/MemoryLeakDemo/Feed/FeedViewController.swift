//
//  FeedViewController.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/1.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import XCGLogger
import UITableView_FDTemplateLayoutCell

extension UINavigationController {
    var rootViewController: UIViewController? {
        return self.viewControllers.first
    }
}

/**
 触发view(Will|Did)Appear的原因

 - Fresh: 首次展示
 - Reveal: 其他Controller消失,如pop,dismiss
 */
enum AppearReason: Int {
    case Fresh = 0
    case Reveal = 1
}

/**
 触发view(Will|Did)Disappear的原因

 - StepDown: 后退,让其他页面显示内容
 - Destroy:  将要被销毁
 */
enum DisappearReason: Int {
    case StepDown = 0
    case Destroy = 1
    case interactivePopGestureCanceled = 3
}

extension UIViewController: UINavigationControllerDelegate {
    func isNavigationRootViewController() -> Bool {
        return self.navigationController?.rootViewController == self
    }

    struct AssociatedObjectKey {
        static var AppearReason = "AppearReason"
    }

    var appearReason: AppearReason {
        get {
            if let reason = objc_getAssociatedObject(self, &AssociatedObjectKey.AppearReason) as? Int {
                if reason != AppearReason.Reveal.rawValue {
                    objc_setAssociatedObject(self, &AssociatedObjectKey.AppearReason, AppearReason.Reveal.rawValue, .OBJC_ASSOCIATION_RETAIN)
                }
                return AppearReason.Reveal
            } else {
                objc_setAssociatedObject(self, &AssociatedObjectKey.AppearReason, AppearReason.Reveal.rawValue, .OBJC_ASSOCIATION_RETAIN)
                return AppearReason.Fresh
            }
        }
    }

    var disappearReason: DisappearReason {
        if self.isMovingFromParentViewController() {
            return DisappearReason.Destroy
        }
        if self.isBeingDismissed() {
            return DisappearReason.Destroy
        }
        if let state = self.navigationController?.interactivePopGestureRecognizer?.state {

            switch state {
            case .Possible: XCGLogger.info("UIGestureRecognizerState.Possible")
            case .Began: XCGLogger.info("UIGestureRecognizerState.Began")
            case .Changed: XCGLogger.info("UIGestureRecognizerState.Changed")
            case .Ended: XCGLogger.info("UIGestureRecognizerState.Ended")
            case .Cancelled: XCGLogger.info("UIGestureRecognizerState.Cancelled")
            case .Failed: XCGLogger.info("UIGestureRecognizerState.Failed")
            }

            if state == .Possible && self.appearReason == .Reveal {
                return DisappearReason.interactivePopGestureCanceled
            }
        }
        return DisappearReason.StepDown
    }
}

class FeedViewController: UIViewController {
    var viewModels = [FeedCellViewModel]()
    var business = FeedBusiness()
    @IBOutlet weak var tableView: UITableView!
}

// MARK: -
extension FeedViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        XCGLogger.info("\(self.appearReason)")

    }

    override func viewDidAppear(animated: Bool) {
        XCGLogger.info("\(self.appearReason)")

        if self.isMovingToParentViewController() || self.navigationController?.viewControllers[0] == self {
            business.loadFeeds().success({ [weak self] viewModels in
                guard let wself = self else { return }
                wself.viewModels.appendContentsOf(viewModels)

                Dispatch.async_on_ui({
                    wself.tableView.reloadData()
                })
            })
        }
    }

    override func viewWillDisappear(animated: Bool) {
        XCGLogger.info("\(self.disappearReason)")
    }

    override func viewDidDisappear(animated: Bool) {
        XCGLogger.info("\(self.disappearReason)")
    }
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
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
// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
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
        // feedCell.favoriteButton.addTarget(self, action: #selector(FeedViewController.favoriteButtonClicked(_:)), forControlEvents: .TouchUpInside)

        feedCell.modifyFavoriteBlock = { [weak self](cell) in
            self?.toggleFavorite(cell)
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let viewModel = viewModels[safe: indexPath.row] else { return }
        XCGLogger.info("\(viewModel)")
    }
}

extension FeedViewController {
    // 需要额外的信息定位是哪个cell
    func favoriteButtonClicked(sender: AnyObject?) {

    }

    func toggleFavorite(cell: FeedCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        // guard let viewModel = viewModels[safe: indexPath.row] else { return }
    }
}
