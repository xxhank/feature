//
//  RorateViewController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
import SnapKit

class RorateViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playerContainer: UIView!
    @IBOutlet weak var switchButton: UIButton!
    var lastInterfaceOrientation: UIInterfaceOrientation = .Portrait
}

// MARK: -
extension RorateViewController {
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }

    override func shouldAutorotate() -> Bool {
        return false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        let deviceOrientation = UIDevice.currentDevice().orientation
        if deviceOrientation.isLandscape {
            switchViewMode(switchButton)
        } else {
            if lastInterfaceOrientation != .Portrait {
                UIApplication.sharedApplication().setStatusBarOrientation(.LandscapeRight, animated: false)
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            }
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        lastInterfaceOrientation = UIApplication.sharedApplication().statusBarOrientation
        if lastInterfaceOrientation != .Portrait {
            UIApplication.sharedApplication().setStatusBarOrientation(UIInterfaceOrientation.Portrait, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
    }

    @IBAction func showPortraitViewController(sender: AnyObject) {
        SSHUD.showHUD(model: false, hide: .After(delay: 10))
    }
    @IBAction func switchViewMode(sender: AnyObject) {
        let button = sender as! UIButton
        if button.titleForState(.Normal) == "Max" {
            button.setTitle("Min", forState: .Normal)
            switchToFullScreen()
        } else {
            button.setTitle("Max", forState: .Normal)
            switchToHalfScreen()
        }
    }
    func switchToHalfScreen() {
        UIApplication.sharedApplication().setStatusBarOrientation(.Portrait, animated: false)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)

        playerView.frame = playerContainer.bounds
        playerContainer.addSubview(playerView)
        playerView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(playerContainer)
            make.centerY.equalTo(playerContainer)
            make.width.equalTo(playerContainer.bounds.width)
            make.height.equalTo(playerContainer.bounds.height)
        }
        UIView.beginAnimations(nil, context: nil)
        playerView.transform = CGAffineTransformIdentity
        UIView.commitAnimations()
    }
    func switchToFullScreen() {
        UIApplication.sharedApplication().setStatusBarOrientation(.LandscapeRight, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .None)

        let size = UIScreen.mainScreen().bounds
        view.addSubview(playerView)
        playerView.frame = view.bounds
        playerView.snp_remakeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.width.equalTo(size.width)
            make.height.equalTo(size.height)
        }

        let angle = UIApplication.sharedApplication().statusBarOrientation == .LandscapeLeft ? -CGFloat(M_PI_2) : CGFloat(M_PI_2)
        UIView.beginAnimations(nil, context: nil)
        playerView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle)
        UIView.commitAnimations()
    }
}
