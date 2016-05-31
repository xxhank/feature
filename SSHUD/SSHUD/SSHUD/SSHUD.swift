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
    class func showHUD(model model: Bool, hide: HUDHide, position: HUDPosition = HUDPosition.Center) {
        SSHUD.hud.showHUD(model: model, hide: hide, position: position)
    }
    lazy var backgroundGesture: UITapGestureRecognizer = {
        SSLogInfo("create background gesture")
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
        gesture.delegate = self
        return gesture
    }()

    let window = HUDWindow()
    lazy var contentView: UIView = {
        let label = UILabel()
        label.text = "Message"
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        return label
    }()
    var hideMethod = HUDHide.Auto
    var autoHideTimer: NSTimer? = nil

    override init() {
        super.init()
        NSNotificationCenter.defaultCenter()
            .addObserver(self, selector: #selector(statusBarRotated(_:)), name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }

    func statusBarRotated(notification: NSNotification) {
        updateContentView()
    }

    func updateContentView() {
        SSLogInfo("\(UIApplication.sharedApplication().statusBarOrientation.rawValue)")
        SSLogInfo("\(UIDevice.currentDevice().orientation.rawValue)")
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        let deviceOrientation = UIDevice.currentDevice().orientation
        switch orientation {
        case .LandscapeLeft:
            if deviceOrientation != UIDeviceOrientation.LandscapeRight {
                let angle = -CGFloat(M_PI_2)
                UIView.beginAnimations(nil, context: nil)
                contentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle)
                UIView.commitAnimations()
            }
        case .LandscapeRight:
            if deviceOrientation != UIDeviceOrientation.LandscapeLeft {
                let angle = CGFloat(M_PI_2)
                UIView.beginAnimations(nil, context: nil)
                contentView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle)
                UIView.commitAnimations()
            }
        case .Portrait:
            if deviceOrientation != UIDeviceOrientation.Portrait {
                UIView.beginAnimations(nil, context: nil)
                contentView.transform = CGAffineTransformIdentity
                UIView.commitAnimations()
            }
        default: break
        }
    }

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
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.8)
        window.addSubview(contentView)
        window.position = position
        updateContentView()
        if model {
            window.backgroundColor = UIColor(white: 0, alpha: 0.1)
        } else {
            window.backgroundColor = UIColor.clearColor()
        }

        window.alpha = 0

        UIView.animateWithDuration(0.2, animations: {
            self.window.alpha = 1
        }) { (finished) in
            self.window.alpha = 1
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

    func autoHideTimerFired() {
        autoHideTimer = nil
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
    var position = HUDPosition.Center
    var padding: CGFloat = 10
    var navigationBarHeight: CGFloat = 64

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.rootViewController = HUDViewController()
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let view = view else { return nil }
        if view.frame.contains(point) {
            return view
        }
        return model ? self : nil
    }

    override func layoutSubviews() {
        guard let contentView = view else { return }
        let window = self

        switch position {
        case .Top:
            contentView.center = CGPoint(x: window.center.x, y: navigationBarHeight + padding + contentView.bounds.height * 0.5)
        case .Center:
            contentView.center = window.center
        case .Bottom:
            contentView.center = CGPoint(x: window.center.x, y: window.bounds.maxY - (padding + contentView.bounds.height * 0.5))
        }
    }
}

/// 适配当前屏幕方向
class HUDViewController: UIViewController {
    override func loadView() {
        self.view = nil
    }

    internal override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let rootViewController = self.rootViewController {
            return rootViewController.supportedInterfaceOrientations()
        } else {
            return UIInterfaceOrientationMask.Portrait
        }
    }

    internal override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if let rootViewController = self.rootViewController {
            return rootViewController.preferredStatusBarStyle()
        } else {
            return .Default
        }
    }

    internal override func prefersStatusBarHidden() -> Bool {
        if let rootViewController = self.rootViewController {
            return rootViewController.prefersStatusBarHidden()
        } else {
            return false
        }
    }

    internal override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        if let rootViewController = self.rootViewController {
            return rootViewController.preferredStatusBarUpdateAnimation()
        } else {
            return .None
        }
    }

    internal override func shouldAutorotate() -> Bool {
        if let rootViewController = self.rootViewController {
            return rootViewController.shouldAutorotate()
        } else {
            return false
        }
    }

    private var rootViewController: UIViewController? {
        return UIApplication.sharedApplication().delegate?.window??.rootViewController
    }
}
