//
//  OtherResultCardContentView.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/25.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage

class OtherResultCardContentView: UIView {
    
    var imageView = UIImageView(frame: CGRectZero)
    var restaurant: Restaurant?
    let contentView = UIView()
    
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame)
        
        self.restaurant = restaurant
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.contentView.layer.masksToBounds = true
        
        self.addSubview(contentView)
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = false
                
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        
        guard let restaurant = self.restaurant else {
            return
        }
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.contentView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.imageView.contentMode = UIViewContentMode.Redraw
        self.contentView.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        // 店名
        let restaurantNameLabel = UILabel(frame: CGRectZero)
        restaurantNameLabel.text = restaurant.shopName
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.RANKING_SECOND_COLOR
        restaurantNameLabel.sizeToFit()
        self.contentView.addSubview(restaurantNameLabel)
        
        restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp_right).offset(12)
            make.top.equalTo(self).offset(14)
            make.height.greaterThanOrEqualTo(14)
            make.right.equalTo(self).offset(-10)
        }
        
        // 距離ラベル
        let distanceLabel = UILabel(frame: CGRectZero)
        distanceLabel.text =  String(format: NSLocalizedString("CardDistanceFromText", comment: ""), restaurant.distance.meterToMinutes())
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.contentView.addSubview(distanceLabel)
        
        distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.bottom.equalTo(self).offset(-14)
            make.height.greaterThanOrEqualTo(12)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 矢印ラベル
        let arrowLabel = UILabel(frame: CGRectZero)
        arrowLabel.text = ">"
        arrowLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        arrowLabel.numberOfLines = 1
        arrowLabel.sizeToFit()
        arrowLabel.textColor =  UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        self.contentView.addSubview(arrowLabel)
        
        arrowLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-8)
            make.centerY.equalTo(self.contentView)
        }

        let imageurls = restaurant.imageUrls.flatMap{NSURL(string: $0)}
        self.acquireImage(imageurls.first!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func acquireImage(url: NSURL?) {
        guard let url = url else {
            self.imageView.image = UIImage(named: "noimage")
            return
        }
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
