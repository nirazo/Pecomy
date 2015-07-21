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
    
    var syncID = ""
    var shopName = ""
    var maxPrice = Int(INT_MAX)
    var minPrice = 0
    var distance: Double = 0.0
    var imageUrls = [NSURL]()
    var restaurantImageViews = [UIImageView]()
    
    init(frame: CGRect, syncID: String, shopName: String, imageUrls: [NSURL], maxPrice: Int, minPrice: Int, distance: Double, options: MDCSwipeToChooseViewOptions) {
        options.likedText = "like"
        options.likedColor = UIColor.blueColor()
        options.nopeText = "dislike"
        options.nopeColor = UIColor.redColor()
        for i in 0..<self.numOfPictures {
            self.restaurantImageViews.append(UIImageView(image: UIImage(named: "noimage")))
        }
        super.init(frame: frame, options: options)
    
        self.syncID = syncID;
        self.shopName = shopName;
        self.imageUrls = imageUrls;
        self.maxPrice = maxPrice;
        self.minPrice = minPrice;
        self.distance = distance;
        
        self.backgroundColor = UIColor.whiteColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // 画像
        self.restaurantImageViews[0].frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*0.4 - self.separatorLineWidth)
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
        // 横線
        var verticalLine = UIBezierPath()
        verticalLine.moveToPoint(CGPointMake(self.frame.width/2, CGRectGetMaxY(self.restaurantImageViews[0].frame)))
        verticalLine.addLineToPoint(CGPointMake(self.frame.width/2, CGRectGetMaxY(self.restaurantImageViews[1].frame)))
        UIColor.whiteColor().setStroke()
        verticalLine.lineWidth = 2
        verticalLine.stroke()

        
        for i in 0..<self.numOfPictures {
            self.addSubview(self.restaurantImageViews[i])
        }
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
