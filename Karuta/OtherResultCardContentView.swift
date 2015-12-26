//
//  OtherResultCardContentView.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/25.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage

class OtherResultCardContentView: ResultCardBase {

    var imageView = UIImageView(frame: CGRectZero)
    
    init(frame: CGRect, restaurant: Restaurant, delegate: ResultCardBaseDelegate) {
        super.init(frame: frame, restaurant: restaurant, imageNum: 1, color: Const.RANKING_TOP_COLOR, delegate: delegate)
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        self.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        // 店名
        let restaurantNameLabel = UILabel(frame: CGRectZero)
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.RANKING_SECOND_COLOR
        restaurantNameLabel.sizeToFit()
        self.addSubview(restaurantNameLabel)
        
        restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp_right).offset(12)
            make.top.equalTo(self).offset(14)
            make.height.greaterThanOrEqualTo(14)
            make.right.equalTo(self).offset(-10)
        }
        self.acquireImages()
    }
    
    private func acquireImages() {
        if imageUrls.count > 0 {
            self.imageView.sd_setImageWithURL(self.imageUrls.first, completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.imageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    weakSelf.imageView.alpha = 1
                    weakSelf.imageView.contentMode = .ScaleAspectFill
                    }, completion: nil)
                })
        } else {
            self.imageView.image = UIImage(named: "noimage")
        }
    }
}
