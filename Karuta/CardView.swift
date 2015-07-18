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
    
    var syncID: String?
    var shopName: String?
    var imageURL: NSURL?
    var maxPrice: Int?
    var minPrice: Int?
    var distance: Double?
    
    init(frame: CGRect, syncID: String, shopName: String, imageURL: NSURL, maxPrice: Int, minPrice: Int, distance: Double, options: MDCSwipeToChooseViewOptions) {
        options.likedText = "like"
        options.likedColor = UIColor.blueColor()
        options.nopeText = "dislike"
        options.nopeColor = UIColor.redColor()
        super.init(frame: frame, options: options)
    
        self.syncID = syncID;
        self.shopName = shopName;
        self.imageURL = imageURL;
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
        let photo = UIImage(named: "noimage");
        self.imageView.image = photo;
        self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.width);
        
        self.imageView.sd_setImageWithURL(self.imageURL, completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
            self?.imageView.alpha = 0
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                self?.imageView.alpha = 1
                }, completion: nil)
        })
    }
}
