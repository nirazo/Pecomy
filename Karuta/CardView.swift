//
//  CardView.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/04.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage
import MDCSwipeToChoose

class CardView: MDCSwipeToChooseView {
    
    let NUM_OF_IMAGES = 3
    
    let CORNER_RADIUS = 5
    
    let SEPARATOR_LINE_WIDTH : CGFloat = 1.0
    let TEXT_MARGIN_X: CGFloat = 10.0
    let TEXT_MARGIN_Y: CGFloat = 10.0
    
    var syncID = ""
    var shopID = ""
    var shopName = ""
    var priceRange = ""
    var distance: Double = 0.0
    var imageUrls = [NSURL]()
    var restaurantImageViews = [UIImageView]()
    var contentsView = UIView()
    
    // カードがフリックされた（操作が無効の状態）になっているかのフラグ
    var isFlicked = false
    
    init(frame: CGRect, restaurant: Restaurant, syncID:String, options: MDCSwipeToChooseViewOptions) {
        options.likedText = "行きたい！"
        options.likedColor = Const.CARD_LIKE_COLOR
        options.nopeText = "イマイチ..."
        options.nopeColor = Const.CARD_DISLIKE_COLOR
        
        self.shopID = restaurant.shopID
        self.shopName = restaurant.shopName
        self.imageUrls = restaurant.imageUrls
        self.priceRange = restaurant.priceRange
        self.distance = restaurant.distance
        self.syncID = syncID
        
        for i in 0..<self.NUM_OF_IMAGES {
            var imageView = UIImageView(image: UIImage(named: "noimage"))
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            self.restaurantImageViews.append(imageView)
        }
        
        super.init(frame: frame, options: options)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 画像
        self.restaurantImageViews[0].frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*0.45 - self.SEPARATOR_LINE_WIDTH)
        self.restaurantImageViews[1].frame = CGRect(x: 0, y: CGRectGetMaxY(self.restaurantImageViews[0].frame) + self.SEPARATOR_LINE_WIDTH, width: self.frame.size.width/2 - self.SEPARATOR_LINE_WIDTH/2, height: self.frame.size.height*0.3)
        self.restaurantImageViews[2].frame = CGRect(x: self.frame.size.width/2 + self.SEPARATOR_LINE_WIDTH, y: self.restaurantImageViews[1].frame.origin.y, width: self.frame.size.width/2 - self.SEPARATOR_LINE_WIDTH/2, height: self.frame.size.height*0.3)
        
        // 横線
        var horizontalLine = UIBezierPath()
        horizontalLine.moveToPoint(CGPointMake(0, CGRectGetMaxY(self.restaurantImageViews[0].frame)))
        horizontalLine.addLineToPoint(CGPointMake(self.frame.width,CGRectGetMaxY(self.restaurantImageViews[0].frame)))
        UIColor.whiteColor().setStroke()
        horizontalLine.lineWidth = 2
        horizontalLine.stroke()
        
        // 縦線
        var verticalLine = UIBezierPath()
        verticalLine.moveToPoint(CGPointMake(self.frame.width/2, CGRectGetMaxY(self.restaurantImageViews[0].frame)))
        verticalLine.addLineToPoint(CGPointMake(self.frame.width/2, CGRectGetMaxY(self.restaurantImageViews[1].frame)))
        UIColor.whiteColor().setStroke()
        verticalLine.lineWidth = 2
        verticalLine.stroke()
        
        for i in 0..<self.imageUrls.count {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        // レストラン名のラベル
        var restaurantNameLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(self.restaurantImageViews[1].frame) + TEXT_MARGIN_Y,
            width: self.frame.width*3/4,
            height: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/4))
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.KARUTA_THEME_COLOR
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        self.addSubview(restaurantNameLabel)
        
        // アイコン
        var iconImageView = UIImageView(image: UIImage(named: "rice"))
        iconImageView.frame = CGRect(x: CGRectGetMaxX(restaurantNameLabel.frame),
            y: CGRectGetMaxY(self.restaurantImageViews[1].frame) + (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/4,
            width: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/2,
            height: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/2)
        self.addSubview(iconImageView)
        
        // 距離ラベル
        var distanceLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(restaurantNameLabel.frame),
            width: restaurantNameLabel.frame.width,
            height: restaurantNameLabel.frame.height))
        distanceLabel.text = "ここから\(Int(self.distance))m"
        distanceLabel.font = UIFont(name: distanceLabel.font.fontName, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 9)
        self.addSubview(distanceLabel)
        
        // 値段ラベル
        var priceLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(distanceLabel.frame),
            width: restaurantNameLabel.frame.width,
            height: (self.frame.height - CGRectGetMaxY(distanceLabel.frame))))
        var replacedString = self.priceRange.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        priceLabel.text = replacedString
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = Const.KARUTA_THEME_COLOR
        priceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        self.addSubview(priceLabel)
        
        
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
