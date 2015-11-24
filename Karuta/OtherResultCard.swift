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
    private let TEXT_MARGIN_X: CGFloat = 10.0
    private let TEXT_MARGIN_Y: CGFloat = 5.0
    
    var rank = 0
    
    init(frame: CGRect, restaurant: Restaurant?, rank: Int) {
        self.rank = rank
        super.init(frame: frame, restaurant: restaurant!, imageNum: NUM_OF_IMAGES, color: Const.KARUTA_RANK_COLOR[rank-1])
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
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
        let restaurantNameLabel = UILabel()
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 10)
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
        let priceLabel = UILabel()
        priceLabel.text = Utils.formatPriceString(self.priceRange)
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = self.borderColor
        priceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 9)
        self.contentView.addSubview(priceLabel)
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.top.equalTo(restaurantNameLabel.snp_bottom).offset(TEXT_MARGIN_Y*2)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 距離ラベル
        let distanceLabel = UILabel()
        distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), self.distance.meterToMinutes())
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 9)
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
        let rankingLabel = UIImageView(frame: CGRectMake(0, 0, 35, 35))
        let image: UIImage
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
        rankingLabel.translatesAutoresizingMaskIntoConstraints = true
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
