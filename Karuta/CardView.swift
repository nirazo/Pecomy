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
    let numOfPictures = 3
    let separatorLineWidth : CGFloat = 1.0
    let textMarginX: CGFloat = 10.0
    let textMarginY: CGFloat = 4.0
    
    var syncID = ""
    var shopName = ""
    var priceRange = ""
    var distance: Double = 0.0
    var imageUrls = [NSURL]()
    var restaurantImageViews = [UIImageView]()
    var contentsView = UIView()
    
    init(frame: CGRect, syncID: String, shopName: String, imageUrls: [NSURL], priceRange: String, distance: Double, options: MDCSwipeToChooseViewOptions) {
        options.likedText = "like"
        options.likedColor = UIColor.blueColor()
        options.nopeText = "dislike"
        options.nopeColor = UIColor.redColor()
        for i in 0..<self.numOfPictures {
            var imageView = UIImageView(image: UIImage(named: "noimage"))
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            self.restaurantImageViews.append(imageView)
        }
        super.init(frame: frame, options: options)
    
        self.syncID = syncID
        self.shopName = shopName
        self.imageUrls = imageUrls
        self.priceRange = priceRange
        self.distance = distance
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 画像
        self.restaurantImageViews[0].frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*0.45 - self.separatorLineWidth)
        self.restaurantImageViews[1].frame = CGRect(x: 0, y: CGRectGetMaxY(self.restaurantImageViews[0].frame) + self.separatorLineWidth, width: self.frame.size.width/2 - self.separatorLineWidth/2, height: self.frame.size.height*0.3)
        self.restaurantImageViews[2].frame = CGRect(x: self.frame.size.width/2 + self.separatorLineWidth, y: self.restaurantImageViews[1].frame.origin.y, width: self.frame.size.width/2 - self.separatorLineWidth/2, height: self.frame.size.height*0.3)
        
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
        
        for i in 0..<self.numOfPictures {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        // レストラン名のラベル
        var restaurantNameLabel = UILabel(frame: CGRect(x: textMarginX,
            y: CGRectGetMaxY(self.restaurantImageViews[1].frame) + textMarginY,
            width: self.frame.width*3/4,
            height: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/4))
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.KARUTA_THEME_COLOR
        self.addSubview(restaurantNameLabel)
        
        // アイコン
        var iconImageView = UIImageView(image: UIImage(named: "rice"))
        iconImageView.frame = CGRect(x: CGRectGetMaxX(restaurantNameLabel.frame),
            y: CGRectGetMaxY(self.restaurantImageViews[1].frame) + (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/4,
            width: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/2,
            height: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/2)
        self.addSubview(iconImageView)
        
        // 距離ラベル
        var distanceLabel = UILabel(frame: CGRect(x: textMarginX,
            y: CGRectGetMaxY(restaurantNameLabel.frame) + self.textMarginY,
            width: restaurantNameLabel.frame.width,
            height: restaurantNameLabel.frame.height))
        distanceLabel.text = "ここから\(Int(self.distance))m"
        distanceLabel.font = UIFont(name: distanceLabel.font.fontName, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        self.addSubview(distanceLabel)
        
        // 値段ラベル
        var priceLabel = UILabel(frame: CGRect(x: textMarginX,
            y: CGRectGetMaxY(distanceLabel.frame),
            width: restaurantNameLabel.frame.width,
            height: (self.frame.height - CGRectGetMaxY(distanceLabel.frame))))
        var replacedString = self.priceRange.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        priceLabel.text = replacedString
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = Const.KARUTA_THEME_COLOR
        priceLabel.font = UIFont(name: priceLabel.font.fontName, size: 12)
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
