//
//  OtherResultCard.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage

class OtherResultCard: ResultCardBase {
    // 描画系定数
    private let NUM_OF_IMAGES = 1
    private let CORNER_RADIUS: CGFloat = 5.0
    private let BORDER_WIDTH: CGFloat = 2.5
    private let TEXT_MARGIN_X: CGFloat = 10.0
    private let TEXT_MARGIN_Y: CGFloat = 5.0
    
    var rank = 0
    var borderColor = UIColor.clearColor()
    
    init(frame: CGRect, restaurant: Restaurant?, rank: Int) {
        super.init(frame: frame, restaurant: restaurant!, imageNum: NUM_OF_IMAGES)
        self.rank = rank
        self.borderColor = Const.KARUTA_RANK_COLOR[rank-1]
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.masksToBounds = false
        
        // ドロップシャドウ
        var shadow = UIView(frame: self.bounds)
        shadow.layer.masksToBounds = false
        self.addSubview(shadow)
        shadow.backgroundColor = UIColor.whiteColor()
        shadow.layer.cornerRadius = CORNER_RADIUS
        shadow.layer.shadowOffset = CGSizeMake(0.5, 1.0);
        shadow.layer.shadowRadius = 0.7;
        shadow.layer.shadowColor = UIColor.grayColor().CGColor
        shadow.layer.shadowOpacity = 0.9;
        
        // パーツ群を置くビュー
        self.contentView = UIView(frame: self.bounds)
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.layer.cornerRadius = CORNER_RADIUS
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = self.borderColor.CGColor
        self.contentView.layer.borderWidth = BORDER_WIDTH
        
        self.addSubview(contentView)
        
        for i in 0..<self.NUM_OF_IMAGES {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        // 画像レイアウト
        self.restaurantImageViews[0].snp_makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(self).multipliedBy(0.55)
        }
        
        // レストラン名のラベル
        var restaurantNameLabel = UILabel()
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.font = UIFont(name: "HiraKakuProN-W6", size: 10)
        restaurantNameLabel.numberOfLines = 2
        restaurantNameLabel.textColor = self.borderColor
        restaurantNameLabel.sizeToFit()
        self.contentView.addSubview(restaurantNameLabel)
        
        restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(TEXT_MARGIN_X)
            make.top.equalTo(self.restaurantImageViews[0].snp_bottom).offset(TEXT_MARGIN_Y)
            make.width.equalTo(self).offset(-TEXT_MARGIN_X*2)
        }
        
        // 値段ラベル
        var priceLabel = UILabel()
        var replacedString = self.priceRange.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        priceLabel.text = replacedString
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = self.borderColor
        priceLabel.font = UIFont(name: "HiraKakuProN-W6", size: 9)
        self.contentView.addSubview(priceLabel)
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.top.equalTo(restaurantNameLabel.snp_bottom).offset(TEXT_MARGIN_Y*2)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 距離ラベル
        var distanceLabel = UILabel()
        distanceLabel.text = "ここから\(Int(self.distance))m"
        distanceLabel.font = UIFont(name: "HiraKakuProN-W3", size: 9)
        distanceLabel.numberOfLines = 1
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(distanceLabel)
        
        distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.bottom.equalTo(self).offset(-TEXT_MARGIN_Y)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // ランキングラベル
        var rankingLabel = UIImageView(frame: CGRectMake(0, 0, 30, 30))
        var image: UIImage
        switch self.rank {
        case 1:
            image = UIImage(named: "first")!
        case 2:
            image = UIImage(named: "second")!
        case 3:
            image = UIImage(named: "third")!
        default:
            image = UIImage()
        }
        
        rankingLabel.image = image
        rankingLabel.center = CGPointMake(10, 10)
        rankingLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.addSubview(rankingLabel)
        
        // 画像のダウンロード
        self.acquireImages()
    }
    
    func acquireImages() {
        if (self.imageUrls.count > 0) {
            for i in 0..<NUM_OF_IMAGES {
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
