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
import SnapKit

protocol CardViewDelegate {
    func blackListButtonTapped(card: CardView, shopID: String)
}

class CardView: MDCSwipeToChooseView {
    
    let NUM_OF_IMAGES = 3
    
    let SEPARATOR_LINE_WIDTH : CGFloat = 1.0
    let TEXT_MARGIN_X: CGFloat = 10.0
    let TEXT_MARGIN_Y: CGFloat = 5.0
    
    var delegate: CardViewDelegate?
    
    var syncID = ""
    var shopID = ""
    var shopName = ""
    var priceRange = ""
    var category = ""
    var distance: Double = 0.0
    var imageUrls = [NSURL]()
    var restaurantImageViews = [UIImageView]()
    let contentsView = UIView()
    let blackListButton = UIButton()
    
    // カードがフリックされた（操作が無効の状態）になっているかのフラグ
    var isFlicked = false
    
    init(frame: CGRect, restaurant: Restaurant, syncID:String, options: MDCSwipeToChooseViewOptions) {
        options.likedText = NSLocalizedString("CardLikeText", comment: "")
        options.likedColor = Const.CARD_LIKE_COLOR
        options.nopeText = NSLocalizedString("CardDislikeText", comment: "")
        options.nopeColor = Const.CARD_DISLIKE_COLOR
        
        self.shopID = restaurant.shopID
        self.shopName = restaurant.shopName
        self.imageUrls = restaurant.imageUrls
        self.priceRange = restaurant.priceRange
        self.distance = restaurant.distance
        self.category = restaurant.category
        self.syncID = syncID
        
        for _ in 0..<self.NUM_OF_IMAGES {
            let imageView = UIImageView(image: UIImage(named: "noimage"))
            imageView.contentMode = .ScaleAspectFit
            imageView.clipsToBounds = true
            imageView.backgroundColor = Const.KARUTA_CARD_IMAGE_BACK_COLOR
            self.restaurantImageViews.append(imageView)
        }
        
        super.init(frame: frame, options: options)
        
        self.setupSubViews()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        // 画像
        self.restaurantImageViews[0].frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height*0.45 - self.SEPARATOR_LINE_WIDTH)
        self.restaurantImageViews[1].frame = CGRect(x: 0, y: CGRectGetMaxY(self.restaurantImageViews[0].frame) + self.SEPARATOR_LINE_WIDTH, width: self.frame.size.width/2 - self.SEPARATOR_LINE_WIDTH/2, height: self.frame.size.height*0.3)
        self.restaurantImageViews[2].frame = CGRect(x: self.frame.size.width/2 + self.SEPARATOR_LINE_WIDTH, y: self.restaurantImageViews[1].frame.origin.y, width: self.frame.size.width/2 - self.SEPARATOR_LINE_WIDTH/2, height: self.frame.size.height*0.3)
        
        for i in 0..<NUM_OF_IMAGES {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        // レストラン名のラベル
        let restaurantNameLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(self.restaurantImageViews[1].frame) + TEXT_MARGIN_Y,
            width: self.frame.width*2/3,
            height: (self.frame.height - CGRectGetMaxY(self.restaurantImageViews[1].frame))/4))
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.KARUTA_THEME_COLOR
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        self.contentView.addSubview(restaurantNameLabel)
        
        // 距離ラベル
        let distanceLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(restaurantNameLabel.frame),
            width: restaurantNameLabel.frame.width,
            height: restaurantNameLabel.frame.height))
        distanceLabel.text =  String(format: NSLocalizedString("CardDistanceFromText", comment: ""), self.distance.meterToMinutes())
        distanceLabel.font = UIFont(name: distanceLabel.font.fontName, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 9)
        self.contentView.addSubview(distanceLabel)
        
        
        // カテゴリ
        let categoryLabelView = CategoryLabelView(frame: CGRectZero, category: self.category)
        
        self.contentView.addSubview(categoryLabelView)
        
        categoryLabelView.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel.snp_right).offset(TEXT_MARGIN_X)
            make.right.equalTo(self.contentView).inset(TEXT_MARGIN_X)
            make.top.equalTo(restaurantNameLabel)
            make.height.equalTo(restaurantNameLabel).multipliedBy(1.5)
        }
        
        // 値段ラベル
        let priceLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(distanceLabel.frame),
            width: restaurantNameLabel.frame.width,
            height: (self.frame.height - CGRectGetMaxY(distanceLabel.frame))))
        
        priceLabel.text = Utils.formatPriceString(self.priceRange)
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = Const.KARUTA_THEME_COLOR
        priceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        self.contentView.addSubview(priceLabel)
        
        // ブラックリストボタン
        self.blackListButton.setImage(UIImage(named: "nogood_normal"), forState: .Normal)
        self.blackListButton.setImage(UIImage(named: "nogood_tapped"), forState: .Highlighted)
        self.blackListButton.setImage(UIImage(named: "nogood_highlighted"), forState: .Disabled)
        self.blackListButton.addTarget(self, action: "blackListButtonTapped", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.blackListButton)
        
        self.blackListButton.snp_makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.right.equalTo(categoryLabelView.snp_right)
            make.bottom.equalTo(self.contentView).offset(-10)
        }
        
        // 画像のダウンロード
        self.acquireImages()
    }
    
    func acquireImages() {
        if (self.imageUrls.count > 0) {
            for i in 0..<self.imageUrls.count {
                self.restaurantImageViews[i].sd_setImageWithURL(self.imageUrls[i], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                    self!.restaurantImageViews[i].alpha = 0
                    UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                        self?.restaurantImageViews[i].contentMode = .ScaleAspectFill
                        self!.restaurantImageViews[i].alpha = 1
                        }, completion: nil)
                    })
            }
        }
    }
    
    func blackListButtonTapped() {
        self.delegate?.blackListButtonTapped(self, shopID: self.shopID)
    }
}
