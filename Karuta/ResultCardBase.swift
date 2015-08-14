//
//  ResultCardBase.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class ResultCardBase: UIView {
    
    private let CORNER_RADIUS: CGFloat = 5.0
    private let BORDER_WIDTH: CGFloat = 2.5

    var syncID = ""
    var shopID = ""
    var shopName = ""
    var priceRange = ""
    var distance: Double = 0.0
    var imageUrls = [NSURL]()
    var url = NSURL()
    var restaurantImageViews = [UIImageView]()
    var borderColor: UIColor
    var contentView = UIView()
    var shadow = UIView()

    init(frame: CGRect, restaurant: Restaurant, imageNum: Int, color: UIColor) {
        self.shopID = restaurant.shopID
        self.shopName = restaurant.shopName
        self.imageUrls = restaurant.imageUrls
        self.priceRange = restaurant.priceRange
        self.distance = restaurant.distance
        self.url = restaurant.url
        self.borderColor = color
        
        for i in 0..<imageNum {
            var imageView = UIImageView(image: UIImage(named: "noimage"))
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            self.restaurantImageViews.append(imageView)
        }
        super.init(frame: frame)
        
        // ドロップシャドウ
        self.shadow.layer.masksToBounds = false
        self.addSubview(shadow)
        self.shadow.backgroundColor = UIColor.whiteColor()
        self.shadow.layer.cornerRadius = CORNER_RADIUS
        self.shadow.layer.shadowOffset = CGSizeMake(0.5, 1.0);
        self.shadow.layer.shadowRadius = 0.7;
        self.shadow.layer.shadowColor = UIColor.grayColor().CGColor
        self.shadow.layer.shadowOpacity = 0.9;
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.layer.cornerRadius = CORNER_RADIUS
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.borderColor = self.borderColor.CGColor
        self.contentView.layer.borderWidth = BORDER_WIDTH
        
        self.addSubview(contentView)

        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.masksToBounds = false
        
        self.setupViews()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.shadow.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(self)
        }
        self.shadow.layer.frame = self.shadow.bounds
        
        self.contentView.snp_makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(self)
        }
        self.contentView.layer.frame = self.contentView.bounds
    }

}
