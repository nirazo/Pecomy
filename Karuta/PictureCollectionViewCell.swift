//
//  PictureCollectionViewCell.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage

class PictureCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var urlString = "" {
        didSet {
            let url = NSURL(string: urlString)
            self.imageView.sd_setImageWithURL(url, completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.imageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    weakSelf.imageView.alpha = 1
                    }, completion: nil)
                })
        }
    }
    
    override init(frame: CGRect) {
        self.imageView = UIImageView(image: UIImage(named: "noimage"))
        super.init(frame: frame)
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        self.contentView.addSubview(self.imageView)
        
        self.imageView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        self.userInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
