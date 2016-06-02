//
//  SSHUD.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/24.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

public enum HUDDisappear {
    case Auto
    case After(delay: NSTimeInterval)
    case Manual
    case Never
}

public typealias HUDLayoutMethod = (canvas: UIView, content: UIView) -> Void
public enum HUDLayout {
    case Top
    case Center
    case Bottom
    case Custom(customeLayout: HUDLayoutMethod)
}

func SSHUDTest() {
    SSHUD.hud
        .model(true)
        .disappear(HUDDisappear.After(delay: 0.3))
        .layout(HUDLayout.Center)
        .show(animated: true)

    SSHUD.hud.hide(animated: true)
}

public typealias HUDCompletion = (finished: Bool) -> Void
extension SSHUD {
    func model(model: Bool) -> Self {
        self.model = model
        return self
    }

    func disappear(disappear: HUDDisappear) -> Self {
        self.disappearMethod = disappear
        return self
    }

    func layout(layout: HUDLayout) -> Self {
        self.layout = layout
        return self
    }

    func content(contentView: UIView) -> Self {
        self.contentView = contentView
        return self
    }
    func completion(completion: HUDCompletion) -> Self {
        self.completion = completion
        return self
    }
}
public class SSHUD: NSObject {
    var model = false
    var layout = HUDLayout.Center
    var contentView: UIView!
    var disappearMethod = HUDDisappear.Auto
    var completion: HUDCompletion?
    var padding: CGFloat = 10
    var navigationBarHeight: CGFloat = 64

    lazy var backgroundGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapBackground(_:)))
        gesture.delegate = self
        return gesture
    }()

    let window = HUDWindow()

    var autoHideTimer: NSTimer? = nil
    var animationDuration = 0.3

    static let hud = SSHUD()
    class func showHUD(model model: Bool, hide: HUDDisappear, position: HUDLayout = HUDLayout.Center) {
        SSHUD.hud.showHUD(model: model, disappear: hide, layout: position)
    }

    override init() {
        super.init()

        window.backgroundColor = UIColor.clearColor()
        window.addGestureRecognizer(backgroundGesture)
        window.layout = { [weak self] canvas, content in
            self?.layoutContentView(canvas, content: content)
        }

        observeStatusBarRotation()
    }

    deinit {
        ignoreStatusBarRotation()
    }

    func showHUD(model model: Bool, disappear: HUDDisappear, layout: HUDLayout = HUDLayout.Center) {
        let contentView = UILabel()
        contentView.textColor = UIColor.whiteColor()
        contentView.text = "Message"
        contentView.backgroundColor = UIColor(white: 0, alpha: 0.6)

        contentView.frame = contentView.textRectForBounds(window.bounds, limitedToNumberOfLines: 3)
        self.model(model)
            .content(contentView)
            .disappear(disappear)
            .layout(layout)
            .show(animated: true)
    }

    func hideHUD(animated animated: Bool = true) {
        hide(animated: animated)
    }

    func prepare() {
        setupAutoHideTimer(self.disappearMethod)

        window.addSubview(contentView)
        window.contentView = contentView
        window.makeKeyAndVisible()

        rorateContentView()
    }

    func show(animated animated: Bool) {
        hide(animated: false)

        prepare()

        if animated {
            window.alpha = 0
            UIView.animateWithDuration(animationDuration, animations: {
                self.window.alpha = 1
            }) { (finished) in
                self.window.alpha = 1
            }
        } else {
        }
    }

    func hide(animated animated: Bool) {
        if animated {
            UIView.animateWithDuration(animationDuration, animations: {
                self.window.alpha = 0
            }) { (finished) in
                self.contentView.removeFromSuperview()
                self.window.alpha = 0
                self.window.hidden = true
            }
        } else {
            self.contentView.removeFromSuperview()
            self.window.alpha = 0
            self.window.hidden = true
        }
        autoHideTimer?.invalidate()
        autoHideTimer = nil
    }

    func tapBackground(gesture: AnyObject) {
        SSLogInfo("tapBackground")
        switch disappearMethod {
        case .Manual:
            hideHUD(animated: true)
        default: break
        }
    }

    func setupAutoHideTimer(hide: HUDDisappear) {
        self.disappearMethod = hide
        autoHideTimer?.invalidate()

        switch hide {
        case .After(let delay):
            autoHideTimer = NSTimer.scheduledTimerWithTimeInterval(delay, target: self, selector: #selector(autoHideTimerFired), userInfo: nil, repeats: false)
        case .Auto:
            autoHideTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(autoHideTimerFired), userInfo: nil, repeats: false)
        default: break
        }
    }

    func autoHideTimerFired() {
        hideHUD(animated: true)
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
// MARK: - Observe Status Bar Rotation
extension SSHUD {
    func observeStatusBarRotation() {
        NSNotificationCenter.defaultCenter()
            .addObserver(self,
                selector: #selector(statusBarRotated(_:)),
                name: UIApplicationDidChangeStatusBarOrientationNotification,
                object: nil)
    }

    func ignoreStatusBarRotation() {
        NSNotificationCenter.defaultCenter()
            .removeObserver(self,
                name: UIApplicationDidChangeStatusBarOrientationNotification,
                object: nil)
    }

    func statusBarRotated(notification: NSNotification) {
        rorateContentView()
    }

    func rorateContentView() {
        let statusBarOrientation = UIApplication.sharedApplication().statusBarOrientation
        let deviceOrientation = UIDevice.currentDevice().orientation

        SSLogInfo("\(statusBarOrientation)")
        SSLogInfo("\(deviceOrientation)")

        switch statusBarOrientation {
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
}

extension SSHUD {
    func layoutContentView(canvas: UIView, content: UIView) {
        switch layout {
        case .Top:
            contentView.center = CGPoint(x: window.center.x, y: navigationBarHeight + padding + contentView.bounds.height * 0.5)
        case .Center:
            contentView.center = window.center
        case .Bottom:
            contentView.center = CGPoint(x: window.center.x, y: window.bounds.maxY - (padding + contentView.bounds.height * 0.5))
        case .Custom(let customeLayout):
            customeLayout(canvas: window, content: contentView)
        }
    }
}