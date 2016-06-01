//
//  SoftwareCell.swift
//  DownloadManager
//
//  Created by wangchao9 on 16/6/1.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit

protocol SoftwareCellDelegate: class {
    func removeTask(cell: UITableViewCell)
    func switchStatus(cell: UITableViewCell, button: UIButton?)
}

class SoftwareCell: UITableViewCell {

    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var statusButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var totalSizeLabel: UILabel!

    var viewModel: DownloadTask? {
        didSet {
            guard let viewModel = viewModel else { return }
            taskNameLabel.text = viewModel.key
            statusButton.setTitle(viewModel.status.rawValue, forState: .Normal)
            progressView.progress = viewModel.progress
            progressLabel.text = "0"
            totalSizeLabel.text = "0"

            viewModel.statusObsever = { [weak self](status) in
                dispatch_async(dispatch_get_main_queue(), {
                    self?.statusButton.setTitle(status.rawValue, forState: .Normal)
                })
            }
            viewModel.progressObserver = { [weak self](progress) in
                dispatch_async(dispatch_get_main_queue(), {
                    self?.progressView.progress = progress
                })
            }
        }
    }
    weak var delegate: SoftwareCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func removeTask(sender: AnyObject) {
        delegate?.removeTask(self)
    }
    @IBAction func switchDown(sender: AnyObject) {
        delegate?.switchStatus(self, button: sender as? UIButton)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
