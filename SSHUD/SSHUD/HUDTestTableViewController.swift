//
//  HUDTestTableViewController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/24.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class HUDTestTableViewController: UITableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            SSHUD.hud.showHUD(model: false, hide: HUDHide.Never)
        case 1:
            SSHUD.hud.showHUD(model: true, hide: HUDHide.Manual)
        case 2:
            SSHUD.hud.showHUD(model: false, hide: HUDHide.Auto)
        case 3:
            SSHUD.hud.showHUD(model: true, hide: HUDHide.Auto)
        case 4:
            self.performSegueWithIdentifier("showKeyboardDemoScene", sender: nil)
        case 5:
            SSHUD.hud.showHUD(model: true, hide: HUDHide.Manual, position: HUDPosition.Top)
        case 6:
            SSHUD.hud.showHUD(model: true, hide: HUDHide.Manual, position: HUDPosition.Bottom)
        default:
            SSLogInfo(indexPath)
        }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var title = "not processed"
        switch indexPath.row {
        case 0: title = "model: false, hide: nevel"
        case 1: title = "model: true, hide: Manual"
        case 2: title = "model: false, hide: Auto"
        case 3: title = "model: true, hide: Auto"
        case 4: title = "keyboard model: false, hide: nevel"
        case 5: title = "model: true, hide: Manual position:Top"
        case 6: title = "model: true, hide: Manual position:Bottom"

        default: break
        }
        cell.textLabel?.text = title
    }
}
