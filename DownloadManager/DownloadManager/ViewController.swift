//
//  SoftwareDownloadViewController.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/5/31.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit

class SoftwareDownloadViewController: UIViewController {
    let datas = [
        ["key": "NavicatPremium11-2-11.dmg ", "url": "http://free2.macx.cn:8281/tools/other5/NavicatPremium11-2-11.dmg"],
        ["key": "Compressor422.dmg ", "url": "http://free2.macx.cn:8281/Desgin/movie/Compressor422.dmg"],
        ["key": "Deckset161.dmg ", "url": "http://free2.macx.cn:8281/tools/other5/Deckset161.dmg"],
        ["key": "CaptureOne9-1-2-16.dmg ", "url": "http://free2.macx.cn:8281/desgin/photo/CaptureOne9-1-2-16.dmg"],
        ["key": "OmniPlan34.dmg ", "url": "http://free2.macx.cn:8281/tools/other5/OmniPlan34.dmg"],
        ["key": "ARESCommander2016-1-1-2059.dmg ", "url": "http://free2.macx.cn:8281/tools/other5/ARESCommander2016-1-1-2059.dmg"],
        ["key": "Gemini212.dmg ", "url": "http://free2.macx.cn:8281/tools/other5/Gemini212.dmg"]];

    @IBOutlet weak var tableView: UITableView!
    let manager = DownloadManager.manager("softwares.db");

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.tableFooterView = UIView()

        datas.forEach { (soft) in
            manager.append(DownloadTask(key: soft["key"]!, url: soft["url"]!))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// MARK: -
extension SoftwareDownloadViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let task = manager.taskAtIndex(indexPath.row), let softwareCell = cell as? SoftwareCell {
            softwareCell.viewModel = task
            softwareCell.delegate = self
        }
    }
}

extension SoftwareDownloadViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.numberOfTasks
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("SoftwareCell")!
    }
}

// MARK: - SoftwareCellDelegate
extension SoftwareDownloadViewController: SoftwareCellDelegate {
    func removeTask(cell: UITableViewCell) {
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        manager.removeAtIndex(indexPath.row)
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }

    func switchStatus(cell: UITableViewCell, button: UIButton?) {
        guard let indexPath = tableView.indexPathForCell(cell) else { return }
        guard let task = manager.taskAtIndex(indexPath.row) else { return }

        switch task.status {
        case .Waiting, .Paused, .Failed:
            manager.start(atIndex: indexPath.row)
        case .Downloading:
            manager.pause(atIndex: indexPath.row)
        case .Finished: break
        }
    }
}

