//
//  HUDViewController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/31.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

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
