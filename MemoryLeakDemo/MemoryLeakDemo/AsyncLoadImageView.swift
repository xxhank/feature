//
//  AsyncLoadImageView.swift
//  MemoryLeakDemo
//
//  Created by wangchao on 16/7/6.
//  Copyright © 2016年 wangchao. All rights reserved.
//

import UIKit
import SDWebImage

class AsyncLoadImageView: UIImageView {
    override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override init(image: UIImage?) {
        super.init(image: image)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    var async_image: NSURL? {
        didSet {
            if let url = async_image {
                self.sd_setImageWithURL(url)
            }else {
                self.sd_cancelCurrentImageLoad()
            }
        }
    }
}