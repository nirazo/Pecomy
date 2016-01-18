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
    
    var restaurant: Restaurant?
    
    var syncID = ""
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
        
        self.restaurant = restaurant
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
        restaurantNameLabel.text = self.restaurant!.shopName
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.KARUTA_THEME_COLOR
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        self.contentView.addSubview(restaurantNameLabel)
        
        // 距離ラベル
        let distanceLabel = UILabel(frame: CGRect(x: TEXT_MARGIN_X,
            y: CGRectGetMaxY(restaurantNameLabel.frame),
            width: restaurantNameLabel.frame.width,
            height: restaurantNameLabel.frame.height))
        distanceLabel.text =  String(format: NSLocalizedString("CardDistanceFromText", comment: ""), self.restaurant!.distance.meterToMinutes())
        distanceLabel.font = UIFont(name: distanceLabel.font.fontName, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor.grayColor()
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 9)
        self.contentView.addSubview(distanceLabel)
        
        
        // カテゴリ
        let categoryLabelView = CategoryLabelView(frame: CGRectZero, category: self.restaurant!.category)
        
        self.contentView.addSubview(categoryLabelView)
        
        categoryLabelView.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel.snp_right).offset(TEXT_MARGIN_X)
            make.right.equalTo(self.contentView).inset(TEXT_MARGIN_X)
            make.top.equalTo(restaurantNameLabel)
            make.height.equalTo(restaurantNameLabel).multipliedBy(1.5)
        }
        
        // 値段ラベル
        let dayPriceLabel = UILabel(frame: CGRectZero)
        if (self.restaurant!.dayPriceMin.isEmpty && self.restaurant!.dayPriceMax.isEmpty) {
            dayPriceLabel.text = "[\(NSLocalizedString("Day", comment: ""))] -"
        } else {
        dayPriceLabel.text = "[\(NSLocalizedString("Day", comment: ""))] \(Utils.formatPriceString(self.restaurant!.dayPriceMin))〜\(Utils.formatPriceString(self.restaurant!.dayPriceMax))"
        }
        dayPriceLabel.numberOfLines = 1
        dayPriceLabel.sizeToFit()
        dayPriceLabel.textColor = Const.KARUTA_THEME_COLOR
        dayPriceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        self.contentView.addSubview(dayPriceLabel)
        dayPriceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.right.equalTo(categoryLabelView)
            make.top.equalTo(distanceLabel.snp_bottom).offset(4)
            make.height.equalTo(14)
        }
        
        let nightPriceLabel = UILabel(frame: CGRectZero)
        
        if (self.restaurant!.nightPriceMin.isEmpty && self.restaurant!.nightPriceMax.isEmpty) {
            nightPriceLabel.text = "[\(NSLocalizedString("Night", comment: ""))] -"
        } else {
            nightPriceLabel.text = "[\(NSLocalizedString("Night", comment: ""))] \(Utils.formatPriceString(self.restaurant!.nightPriceMin))〜\(Utils.formatPriceString(self.restaurant!.nightPriceMax))"
        }
        nightPriceLabel.numberOfLines = 1
        nightPriceLabel.sizeToFit()
        nightPriceLabel.textColor = Const.KARUTA_THEME_COLOR
        nightPriceLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        self.contentView.addSubview(nightPriceLabel)
        nightPriceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.right.equalTo(categoryLabelView)
            make.top.equalTo(dayPriceLabel.snp_bottom).offset(2)
            make.height.equalTo(14)
        }
        
        #if !RELEASE
        // ブラックリストボタン(Releaseバージョンには乗せない)
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
        #endif
        
        // 画像のダウンロード
        self.acquireImages()
    }
    
    func acquireImages() {
        let loopCount = self.restaurant!.imageUrls.count < NUM_OF_IMAGES ? self.restaurant!.imageUrls.count: NUM_OF_IMAGES
        for i in 0..<loopCount {
            self.restaurantImageViews[i].sd_setImageWithURL(NSURL(string: self.restaurant!.imageUrls[i]), completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.restaurantImageViews[i].alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self?.restaurantImageViews[i].contentMode = .ScaleAspectFill
                    self!.restaurantImageViews[i].alpha = 1
                    }, completion: nil)
                })
        }
    }
    
    func blackListButtonTapped() {
        self.delegate?.blackListButtonTapped(self, shopID: self.restaurant!.shopID)
    }
}
