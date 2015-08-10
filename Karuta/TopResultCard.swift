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
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame, restaurant: restaurant, imageNum: NUM_OF_IMAGES)
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
        shadow.layer.shadowRadius = 0.9;
        shadow.layer.shadowColor = UIColor.grayColor().CGColor
        shadow.layer.shadowOpacity = 0.7;
        
        // パーツ群を置くビュー
        self.contentView = UIView(frame: self.bounds)
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.layer.cornerRadius = CORNER_RADIUS
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = Const.RANKING_TOP_COLOR.CGColor
        self.contentView.layer.borderWidth = BORDER_WIDTH
        
        self.addSubview(contentView)
        
        for i in 0..<self.imageUrls.count {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        // 画像レイアウト
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
        var restaurantNameLabel = UILabel()
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        restaurantNameLabel.numberOfLines = 2
        restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        restaurantNameLabel.sizeToFit()
        self.contentView.addSubview(restaurantNameLabel)
        
        restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(TEXT_MARGIN_X)
            make.top.equalTo(self.restaurantImageViews[0].snp_bottom).offset(TEXT_MARGIN_Y)
            make.width.equalTo(self).multipliedBy(0.75)
        }
        
        // 値段ラベル
        var priceLabel = UILabel()
        var replacedString = self.priceRange.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        priceLabel.text = replacedString
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = Const.RANKING_TOP_COLOR
        priceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        self.contentView.addSubview(priceLabel)
        
        priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.top.equalTo(restaurantNameLabel.snp_bottom).offset(TEXT_MARGIN_Y*2)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 距離ラベル
        var distanceLabel = UILabel()
        distanceLabel.text = "ここから\(Int(self.distance))m"
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 10)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        self.contentView.addSubview(distanceLabel)
        
        distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.bottom.equalTo(self).offset(-TEXT_MARGIN_Y)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 矢印ラベル
        var arrawLabel = UILabel()
        arrawLabel.text = ">"
        arrawLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 20)
        arrawLabel.numberOfLines = 1
        arrawLabel.sizeToFit()
        arrawLabel.textColor = Const.RANKING_TOP_COLOR
        self.contentView.addSubview(arrawLabel)
        
        arrawLabel.snp_makeConstraints { (make) in
            make.right.equalTo(self).offset(-TEXT_MARGIN_X)
            make.centerY.equalTo(priceLabel)
        }
        
        // ランキングラベル
        var rankingLabel = UIImageView(image: UIImage(named: "first"))
        rankingLabel.bounds = CGRectMake(0, 0, 45, 45)
        rankingLabel.center = CGPointMake(10, 10)
        rankingLabel.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.addSubview(rankingLabel)
        
//        // 水平線
//        var horizontalLineView = UIView()
//        horizontalLineView.backgroundColor = Const.RANKING_TOP_COLOR
//        self.contentView.addSubview(horizontalLineView)
//        horizontalLineView.snp_makeConstraints { (make) in
//            make.left.equalTo(self)
//            make.top.equalTo(distanceLabel.snp_bottom).offset(TEXT_MARGIN_Y*2)
//            make.width.equalTo(self)
//            make.height.equalTo(SEPARATOR_LINE_WIDTH)
//        }
//        
//        // 垂直線
//        var verticalLineView = UIView()
//        verticalLineView.backgroundColor = Const.RANKING_TOP_COLOR
//        self.contentView.addSubview(verticalLineView)
//        verticalLineView.snp_makeConstraints { (make) in
//            make.left.equalTo(self).offset(self.frame.size.width*2/3)
//            make.top.equalTo(horizontalLineView)
//            make.width.equalTo(SEPARATOR_LINE_WIDTH)
//            make.height.equalTo(self).offset(horizontalLineView.frame.origin.y)
//        }
//        
//        
//        // 電話番号
//        var telNumView = UIView()
//        self.contentView.addSubview(telNumView)
//        telNumView.snp_makeConstraints { (make) in
//            make.left.equalTo(self)
//            make.right.equalTo(verticalLineView.snp_left)
//            make.top.equalTo(horizontalLineView.snp_bottom)
//            make.bottom.equalTo(self)
//        }
//        var telNumLabel = UILabel()
//        telNumLabel.text = "050-5571-1724"
//        telNumLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 15)
//        telNumLabel.numberOfLines = 1
//        telNumLabel.textColor = UIColor.blackColor()
//        telNumLabel.textAlignment = .Center
//        telNumLabel.sizeToFit()
//        self.contentView.addSubview(telNumLabel)
//        telNumLabel.snp_makeConstraints { (make) in
//            make.center.equalTo(telNumView)
//        }
//        
//        // 地図
//        var mapTextView = UIView()
//        self.contentView.addSubview(mapTextView)
//        mapTextView.snp_makeConstraints { (make) in
//            make.left.equalTo(verticalLineView.snp_right)
//            make.right.equalTo(self)
//            make.top.equalTo(telNumView)
//            make.bottom.equalTo(self)
//        }
//        var mapLabel: UILabel = UILabel()
//        mapLabel.text = "地図"
//        mapLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
//        mapLabel.numberOfLines = 1
//        mapLabel.textColor = Const.RANKING_TOP_COLOR
//        mapLabel.textAlignment = .Center
//        self.contentView.addSubview(mapLabel)
//        
//        mapLabel.snp_makeConstraints { (make) in
//            make.center.equalTo(mapTextView)
//        }
        
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
