//
//  HUDWindow.swift
//  SSHUD
//
//  Created by wangchaojs02 on 16/5/31.
//  Copyright © 2016年 wangchaojs02. All rights reserved.
//

import UIKit

class HUDWindow: UIWindow {
    var model = false
    var contentView: UIView? = nil
    var layout: HUDLayoutMethod?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        self.rootViewController = HUDViewController()
    }

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        guard let view = contentView else { return nil }
        if view.frame.contains(point) {
            return view
        }
        return model ? self : nil
    }

    override func layoutSubviews() {
        guard let contentView = contentView else { return }
        let window = self
        if let layout = layout {
            layout(canvas: window, content: contentView)
        }
    }
}