//
//  ResultCardBase.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class ResultCardBase: UIView {

    var syncID = ""
    var shopID = ""
    var shopName = ""
    var priceRange = ""
    var distance: Double = 0.0
    var imageUrls = [NSURL]()
    var url = NSURL()
    var restaurantImageViews = [UIImageView]()
    var contentView = UIView()

    init(frame: CGRect, restaurant: Restaurant, imageNum: Int) {
        self.shopID = restaurant.shopID
        self.shopName = restaurant.shopName
        self.imageUrls = restaurant.imageUrls
        self.priceRange = restaurant.priceRange
        self.distance = restaurant.distance
        self.url = restaurant.url
        
        for i in 0..<imageNum {
            var imageView = UIImageView(image: UIImage(named: "noimage"))
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            self.restaurantImageViews.append(imageView)
        }
        super.init(frame: frame)
        self.backgroundColor = UIColor.clearColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
