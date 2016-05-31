//
//  ProtraitViewController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class PortraitViewController: SSViewController {
    @IBAction func showHUD(sender: AnyObject) {
        SSHUD.showHUD(model: true, hide: .Manual)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
