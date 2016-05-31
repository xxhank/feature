//
//  HUDTestTableViewController.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/24.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit
typealias Action = (indexPath: NSIndexPath) -> Void

struct RowData {
    var title: String
    var action: Action
}
class HUDTestTableViewController: UITableViewController {
    var datas = [RowData]()
    override func viewDidLoad() {

        datas = [
            RowData(title: "model: false, hide: nevel", action: { (indexPath) in
                SSHUD.showHUD(model: false, hide: .Never)
            }),
            RowData(title: "model: true, hide: Manual", action: { (indexPath) in
                SSHUD.showHUD(model: true, hide: .Manual)
            }),
            RowData(title: "model: false, hide: Auto", action: { (indexPath) in
                SSHUD.showHUD(model: false, hide: .Auto)
            }),
            RowData(title: "model: true, hide: Auto", action: { (indexPath) in
                SSHUD.showHUD(model: true, hide: .Auto)
            }),
            RowData(title: "keyboard model: false, hide: nevel", action: { (indexPath) in
                self.performSegueWithIdentifier("showKeyboardDemoScene", sender: nil)
            }),
            RowData(title: "model: true, hide: Manual position:Top", action: { (indexPath) in
                SSHUD.showHUD(model: true, hide: .Manual, position: .Top)
            }),
            RowData(title: "model: true, hide: Manual position:Bottom", action: { (indexPath) in
                SSHUD.showHUD(model: true, hide: .Manual, position: .Bottom)
            }),
            RowData(title: "show RorateViewController", action: { (indexPath) in
                self.performSegueWithIdentifier("showRorateViewController", sender: nil)
            })]
        super.viewDidLoad()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row < datas.count {
            let rowData = datas[indexPath.row]
            rowData.action(indexPath: indexPath)
        }
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        var title = "not processed"
        if indexPath.row < datas.count {
            let rowData = datas[indexPath.row]
            title = rowData.title
        }

        cell.textLabel?.text = title
    }
}
