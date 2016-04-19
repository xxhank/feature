//
//  ViewController.swift
//  GenericAndExtension
//
//  Created by wangchao9 on 16/4/12.
//  Copyright © 2016年 wangchao9. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let g = GClass<Int>(value: 10)
        print(g.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
