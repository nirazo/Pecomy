//
//  ResultViewCell.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/12.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ResultViewCell: UITableViewCell {
    
    let CORNER_RADIUS: CGFloat = 5.0
    let NUM_OF_PICTURES = 3
    let IMAGE_SEPARATOR_WIDTH : CGFloat = 1.0
    let TEXT_MARGIN_X: CGFloat = 10.0
    let TEXT_MARGIN_Y: CGFloat = 4.0

    var titleLabel = UILabel()
    var numberLabel = UILabel()
    var restaurantImageViews = [UIImageView]()
    var categoryLabel = UILabel()
    var priceRangeLabel = UILabel()
    var distanceLabel = UILabel()
    var cellView = UIView()
    
    var restaurant: Restaurant!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 各パーツを配備するビュー
        self.cellView = UIView()
        self.contentView.addSubview(self.cellView)
        
        // 順位
        self.numberLabel = UILabel()
        self.numberLabel.textAlignment = .Center
        self.numberLabel.backgroundColor = Const.KARUTA_THEME_COLOR
        self.numberLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
        self.numberLabel.clipsToBounds = true
        self.numberLabel.font = .boldSystemFontOfSize(18)
        
        // 店舗画像
        for i in 0..<self.NUM_OF_PICTURES {
            var imageView = UIImageView()
            imageView.contentMode = .ScaleAspectFill
            imageView.clipsToBounds = true
            self.restaurantImageViews.append(imageView)
        }
        
        // 店名
        self.titleLabel = UILabel()
        self.titleLabel.autoresizingMask = .FlexibleWidth
        self.titleLabel.font = .boldSystemFontOfSize(18)
        self.titleLabel.numberOfLines = 2
        //self.titleLabel.sizeToFit()
        
        // 金額
        self.priceRangeLabel = UILabel()
        self.priceRangeLabel.autoresizingMask = .FlexibleWidth
        self.priceRangeLabel.font = .systemFontOfSize(12)
        self.priceRangeLabel.numberOfLines = 2
        self.priceRangeLabel.sizeToFit()
        
        // 距離
        self.distanceLabel = UILabel()
        self.distanceLabel.autoresizingMask = .FlexibleWidth
        self.distanceLabel.font = .systemFontOfSize(12)
        self.distanceLabel.numberOfLines = 1
        self.distanceLabel.sizeToFit()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithRestaurant(restaurant: Restaurant) {
        self.restaurant = restaurant
        
        self.cellView.backgroundColor = UIColor.whiteColor()
        self.cellView.snp_makeConstraints { (make) in
            make.height.equalTo(self.contentView).multipliedBy(0.95)
            make.width.equalTo(self.contentView).multipliedBy(0.96)
            make.center.equalTo(self.contentView)
        }
        
        self.cellView.addSubview(self.numberLabel)
        self.numberLabel.snp_makeConstraints { (make) in
            make.width.equalTo(self.cellView)
            make.height.equalTo(self.cellView).multipliedBy(0.15)
            make.top.equalTo(self.cellView)
            make.left.equalTo(self.cellView)
        }
        
        for i in 0..<self.NUM_OF_PICTURES {
            self.cellView.addSubview(restaurantImageViews[i])
        }
        self.restaurantImageViews[0].snp_makeConstraints { (make) in
            make.width.equalTo(self.numberLabel).multipliedBy(0.4)
            make.height.equalTo(self.cellView).offset(-self.numberLabel.frame.height).multipliedBy(0.5).offset(-self.IMAGE_SEPARATOR_WIDTH/2)
            make.top.equalTo(self.numberLabel.snp_bottom)
            make.left.equalTo(self.cellView)
        }
        self.restaurantImageViews[1].snp_makeConstraints { (make) in
            make.width.equalTo(self.restaurantImageViews[0]).multipliedBy(0.5).offset(-self.IMAGE_SEPARATOR_WIDTH/2)
            make.height.equalTo(self.cellView).offset(-self.numberLabel.frame.height-self.restaurantImageViews[0].frame.height-self.IMAGE_SEPARATOR_WIDTH/2)
            make.top.equalTo(self.restaurantImageViews[0].snp_bottom).offset(self.IMAGE_SEPARATOR_WIDTH)
            make.left.equalTo(self.cellView)
        }
        self.restaurantImageViews[2].snp_makeConstraints { (make) in
            make.width.equalTo(self.restaurantImageViews[1])
            make.height.equalTo(self.restaurantImageViews[1])
            make.top.equalTo(self.restaurantImageViews[1].snp_top)
            make.left.equalTo(self.restaurantImageViews[1].snp_right).offset(self.IMAGE_SEPARATOR_WIDTH)
        }
        self.setRestaurantImage(self.restaurant.imageUrls)
        
        // 店名
        self.titleLabel.text = self.restaurant.shopName
        self.cellView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.numberLabel.snp_bottom).offset(self.TEXT_MARGIN_Y)
            make.left.equalTo(self.numberLabel.snp_right).offset(self.TEXT_MARGIN_X)
            make.width.equalTo(self.cellView.frame.width - self.restaurantImageViews[0].frame.width)
            make.height.equalTo(self.cellView.frame.height - self.numberLabel.frame.height).multipliedBy(0.3)
        }
        
        // 金額
        var replacedString = self.restaurant.priceRange.stringByReplacingOccurrencesOfString("  +", withString: "\n", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
        self.priceRangeLabel.text = replacedString
        self.cellView.addSubview(self.priceRangeLabel)
        self.priceRangeLabel.snp_makeConstraints { (make) in
            
        }
        
        // セルの枠線
        self.cellView.layer.borderColor = UIColor.grayColor().CGColor
        self.cellView.layer.borderWidth = 0.8
        self.cellView.layer.cornerRadius = CORNER_RADIUS
        self.cellView.layer.masksToBounds = true
        
        // ドロップシャドウ
        var shadow = UIView()
        shadow.layer.masksToBounds = false
        shadow.layer.cornerRadius = CORNER_RADIUS
        shadow.backgroundColor = UIColor.whiteColor()
        shadow.layer.shadowOffset = CGSizeMake(0.5, 1.0)
        shadow.layer.shadowRadius = 0.7
        shadow.layer.shadowColor = UIColor.grayColor().CGColor
        shadow.layer.shadowOpacity = 0.9
        self.contentView.addSubview(shadow)
        self.contentView.sendSubviewToBack(shadow)
        shadow.snp_makeConstraints { (make) in
            make.center.equalTo(self.cellView)
            make.width.equalTo(self.cellView)
            make.height.equalTo(self.cellView)
        }
    }
    
    func setRestaurantImage(imageUrls: [NSURL]) {
        for i in 0..<self.NUM_OF_PICTURES {
            self.restaurantImageViews[i].sd_setImageWithURL(imageUrls[i], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self?.restaurantImageViews[0].alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() in
                    self?.restaurantImageViews[0].alpha = 1
                    }, completion: nil)
                })
        }
    }
    
    func numberLabelColor(index: Int) -> UIColor {
        switch index {
        case 0:
            return Const.RANKING_TOP_COLOR
        case 1:
            return Const.RANKING_SECOND_COLOR
        case 2:
            return Const.RANKING_THIRD_COLOR
        default:
            return Const.KARUTA_THEME_COLOR
        }
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
