//
//  SupportPick.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/9.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit

typealias PickCompletion = (result: AnyObject?) -> Void
protocol PickParameters {

}
protocol SupportPick: class {
    static func pickViewController(hostController: UIViewController) -> SupportPick?
    static var topOffset: CGFloat { get }
    func prepare(parameters: PickParameters?)
    var completion: PickCompletion? { get set }
    var topConstraint: NSLayoutConstraint { get }
}

extension SupportPick {
    static func pickEpisode(parameters: PickParameters?, hostController: UIViewController, completion: PickCompletion) {
        guard let viewController = pickViewController(hostController) else {
            return
        }
        viewController.prepare(parameters)
        viewController.completion = { [weak viewController] result in
            hide(viewController!, from: hostController)
            completion(result: result)
        }
        show(viewController, to: hostController)
    }

    static func show(picker: SupportPick, to host: UIViewController) {
        guard let controller = picker as? UIViewController else { return }
        host.addChildViewController(controller)
        controller.view.frame = host.view.bounds
        host.view.addSubview(controller.view)
        controller.didMoveToParentViewController(host)

        controller.view.backgroundColor = UIColor.redColor().colorWithAlphaComponent(0.5)
        controller.view.alpha = 0
        picker.topConstraint.constant = host.view.bounds.height
        controller.view.layoutIfNeeded()

        UIView.animateWithDuration(0.3, animations: {
            picker.topConstraint.constant = topOffset
            controller.view.layoutIfNeeded()
            controller.view.alpha = 1
        }) { (finished) in
            if !finished {
                controller.view.alpha = 1
                picker.topConstraint.constant = topOffset
                controller.view.layoutIfNeeded()
            }
        }
    }

    static func hide(picker: SupportPick, from host: UIViewController) {
        guard let controller = picker as? UIViewController else { return }
        controller.willMoveToParentViewController(nil)

        picker.topConstraint.constant = topOffset

        UIView.animateWithDuration(0.3, animations: {
            picker.topConstraint.constant = host.view.bounds.height
            controller.view.layoutIfNeeded()
            controller.view.alpha = 0
        }) { (finished) in
            controller.view.alpha = 0
            controller.view.removeFromSuperview()
            controller.removeFromParentViewController()
        }
    }
}
