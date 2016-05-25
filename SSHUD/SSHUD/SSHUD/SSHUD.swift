//
//  SSHUD.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/24.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

public enum HUDHide {
    case Auto
    case After(delay: NSTimeInterval)
    case Manual
    case Never
}

public enum HUDPosition {
    case Top
    case Center
    case Bottom
}

public class SSHUD: NSObject {
    static let hud = SSHUD()
    lazy var backgroundGesture: UITapGestureRecognizer = {
        SSLogInfo("create background gesture")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
        gesture.delegate = self
        return gesture
    }()

    let window = HUDWindow()
    let contentView = UIView()
    var hideMethod = HUDHide.Auto
    var autoHideTimer: NSTimer? = nil
    var padding: CGFloat = 10
    var navigationBarHeight: CGFloat = 64

    func showHUD(model model: Bool, hide: HUDHide, position: HUDPosition = HUDPosition.Center) {
        self.hideMethod = hide
        autoHideTimer?.invalidate()

        switch hide {
        case .After(let delay):
            autoHideTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(hideHUD), userInfo: nil, repeats: false)
        case .Auto:
            autoHideTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(hideHUD), userInfo: nil, repeats: false)
        default: break
        }

        contentView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        contentView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.2)
        window.addSubview(contentView)
        switch position {
        case .Top:
            contentView.center = CGPoint(x: window.center.x, y: navigationBarHeight + padding + contentView.bounds.height * 0.5)
        case .Center:
            contentView.center = window.center
        case .Bottom:
            contentView.center = CGPoint(x: window.center.x, y: window.bounds.maxY - (padding + contentView.bounds.height * 0.5))
        }

        if model {
            window.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        } else {
            window.backgroundColor = UIColor.clearColor()
        }
        window.model = model
        window.view = contentView

        window.addGestureRecognizer(backgroundGesture)
        window.makeKeyAndVisible()
    }

    func hideHUD() {
        contentView.removeFromSuperview()
        window.hidden = true
    }

    func tapBackground(gesture: AnyObject) {
        SSLogInfo("tapBackground")
        switch hideMethod {
        case .Manual:
            hideHUD()
        default: break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate
extension SSHUD: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == backgroundGesture {
            let point = gestureRecognizer.locationInView(contentView)
            if contentView.bounds.contains(point) {
                return false
            } else {
                return true
            }
        }
        return true
    }
}

class HUDWindow: UIWindow {
    var model = false
    var view: UIView? = nil
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let view = view else { return nil }
        if view.frame.contains(point) {
            return view
        }
        return model ? self : nil
    }
}