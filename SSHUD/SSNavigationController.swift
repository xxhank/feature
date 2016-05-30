//
//  SSNavigationController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/30.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class SSNavigationController: UINavigationController {
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.visibleViewController?.supportedInterfaceOrientations() ?? .Portrait
    }

    override func shouldAutorotate() -> Bool {
        return self.visibleViewController?.shouldAutorotate() ?? false
    }
}
