//
//  TopResultCard.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage

class TopResultCard: ResultCardBase {

    // 描画系定数
    private let NUM_OF_IMAGES = 3
    private let CORNER_RADIUS: CGFloat = 5.0
    private let BORDER_WIDTH: CGFloat = 2.5
    private let SEPARATOR_LINE_WIDTH : CGFloat = 1.0
    private let TEXT_MARGIN_X: CGFloat = 10.0
    private let TEXT_MARGIN_Y: CGFloat = 10.0
    
    let restaurantNameLabel = UILabel()
    let priceLabel = UILabel()
    let distanceLabel = UILabel()
    let arrawLabel = UILabel()
    let rankingLabel = UIImageView(image: UIImage(named: "first"))
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame, restaurant: restaurant, imageNum: NUM_OF_IMAGES, color: Const.RANKING_TOP_COLOR)
        self.setupSubViews()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        for i in 0..<self.imageUrls.count {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        self.restaurantImageViews[0].snp_makeConstraints { (make) in
            make.width.equalTo(self).multipliedBy(0.65)
            make.height.equalTo(self).multipliedBy(0.60)
            make.left.equalTo(self)
        }
        self.restaurantImageViews[1].snp_makeConstraints { (make) in
            make.left.equalTo(self.restaurantImageViews[0].snp_right).offset(self.SEPARATOR_LINE_WIDTH)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self.restaurantImageViews[0].snp_bottom).multipliedBy(0.5).offset(-self.SEPARATOR_LINE_WIDTH/2)
            make.height.equalTo(self.restaurantImageViews[0].snp_height).multipliedBy(0.5).offset(-self.SEPARATOR_LINE_WIDTH/2)
        }
        self.restaurantImageViews[2].snp_makeConstraints { (make) in
            make.left.equalTo(self.restaurantImageViews[1])
            make.right.equalTo(self)
            make.top.equalTo(self.restaurantImageViews[1].snp_bottom).offset(self.SEPARATOR_LINE_WIDTH)
            make.bottom.equalTo(self.restaurantImageViews[0].snp_bottom)
            make.height.equalTo(self.restaurantImageViews[1].snp_height)
        }
        
        // レストラン名のラベル
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        restaurantNameLabel.numberOfLines = 2
        restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        restaurantNameLabel.sizeToFit()
        self.contentView.addSubview(restaurantNameLabel)
        
        self.restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(TEXT_MARGIN_X)
            make.top.equalTo(self.restaurantImageViews[0].snp_bottom).offset(TEXT_MARGIN_Y)
            make.width.equalTo(self).multipliedBy(0.75)
        }
        
        // 値段ラベル
        var replacedString = self.priceRange.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        
        let prices = replacedString.componentsSeparatedByString("\n")
        
        if (prices.count<2) {
            if (prices[0].isEmpty) {
                priceLabel.text = NSLocalizedString("CardNoPriceInfoText", comment: "")
            } else {
                priceLabel.text = prices[0]
            }
        } else {
            priceLabel.text = prices[1] + "\n" + prices[0]
        }
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = Const.RANKING_TOP_COLOR
        priceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        self.contentView.addSubview(priceLabel)
        
        self.priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.top.equalTo(restaurantNameLabel.snp_bottom).offset(TEXT_MARGIN_Y*2)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 距離ラベル
        distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), Int(self.distance))
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 10)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(distanceLabel)
        
        self.distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.bottom.equalTo(self).offset(-TEXT_MARGIN_Y)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 矢印ラベル
        arrawLabel.text = ">"
        arrawLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 20)
        arrawLabel.numberOfLines = 1
        arrawLabel.sizeToFit()
        arrawLabel.textColor = Const.RANKING_TOP_COLOR
        self.contentView.addSubview(arrawLabel)
        
        self.arrawLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-TEXT_MARGIN_X)
            make.centerY.equalTo(priceLabel)
        }
        
        // ランキングラベル
        rankingLabel.bounds = CGRectMake(0, 0, 45, 45)
        rankingLabel.center = CGPointMake(10, 10)
        rankingLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.addSubview(rankingLabel)
        
        
        // 画像のダウンロード
        self.acquireImages()
    }
    
    func acquireImages() {
        if (self.imageUrls.count > 0) {
            for i in 0..<self.imageUrls.count {
                self.restaurantImageViews[i].sd_setImageWithURL(self.imageUrls[i], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                    self!.restaurantImageViews[i].alpha = 0
                    UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                        self!.restaurantImageViews[i].alpha = 1
                        }, completion: nil)
                    })
            }
        }
    }
}
