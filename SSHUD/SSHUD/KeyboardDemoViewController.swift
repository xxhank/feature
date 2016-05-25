//
//  KeyboardDemoViewController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/25.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class KeyboardDemoViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!

    override func viewDidAppear(animated: Bool) {
        textField.becomeFirstResponder()
        textField.delegate = self
    }
}

// MARK: -
extension KeyboardDemoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        SSHUD.hud.showHUD(model: true, hide: HUDHide.Auto)
        return false
    }
}
