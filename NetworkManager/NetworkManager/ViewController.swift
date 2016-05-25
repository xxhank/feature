//
//  ViewController.swift
//  NetworkManager
//
//  Created by wangchaojs02 on 16/5/16.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

struct BaiduRequest: NetworkRequest {
    var url: String {
        return "http://dldir2.qq.com/invc/xfspeed/softmgr/SoftMgr_Setup_S40106.exe"
    }
    var parameters: [String: AnyObject] {
        return ["r": NSDate().timeIntervalSince1970]
    }
}

class ViewController: UIViewController {
    var token: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func fetchData(sender: AnyObject) {
        // NerworkManager.shared.cancel(token)
        token = NerworkManager.shared.fetch(BaiduRequest())
    }
}
