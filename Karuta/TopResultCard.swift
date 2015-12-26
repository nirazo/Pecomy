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
    private let SEPARATOR_LINE_WIDTH : CGFloat = 3.0
    private let TEXT_MARGIN_X: CGFloat = 16.0
    private let TEXT_MARGIN_Y: CGFloat = 10.0
    
    let restaurantNameLabel = UILabel()
    let priceLabel = UILabel()
    let distanceLabel = UILabel()
    
    init(frame: CGRect, restaurant: Restaurant, delegate: ResultCardBaseDelegate) {
        super.init(frame: frame, restaurant: restaurant, imageNum: NUM_OF_IMAGES, color: Const.RANKING_TOP_COLOR, delegate: delegate)
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
        for i in 0..<NUM_OF_IMAGES {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        
        self.restaurantImageViews[0].snp_makeConstraints { (make) in
            make.width.equalTo(220)
            make.height.equalTo(173)
            make.left.equalTo(self)
            make.top.equalTo(self)
        }

        self.restaurantImageViews[1].snp_makeConstraints { (make) in
            make.left.equalTo(self.restaurantImageViews[0].snp_right).offset(self.SEPARATOR_LINE_WIDTH)
            make.right.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self.restaurantImageViews[0].snp_bottom).multipliedBy(0.5).offset(-self.SEPARATOR_LINE_WIDTH/2)
            make.height.equalTo(85)
        }
        self.restaurantImageViews[2].snp_makeConstraints { (make) in
            make.left.equalTo(self.restaurantImageViews[1])
            make.right.equalTo(self)
            make.top.equalTo(self.restaurantImageViews[1].snp_bottom).offset(self.SEPARATOR_LINE_WIDTH)
            make.bottom.equalTo(self.restaurantImageViews[0].snp_bottom)
            make.height.equalTo(85)
        }
        
        // レストラン名のラベル
        restaurantNameLabel.text = self.shopName
        restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        restaurantNameLabel.numberOfLines = 2
        restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        restaurantNameLabel.sizeToFit()
        self.contentView.addSubview(restaurantNameLabel)
        
        self.restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(TEXT_MARGIN_X)
            make.top.equalTo(self.restaurantImageViews[0].snp_bottom).offset(14)
            make.height.greaterThanOrEqualTo(16)
            make.width.equalTo(166)
        }
        
        // カテゴリ
        let categoryLabelView = CategoryLabelView(frame: CGRectZero, category: self.category, color: Const.RANKING_TOP_COLOR)
        self.contentView.addSubview(categoryLabelView)
        
        categoryLabelView.snp_makeConstraints { (make) in
            make.width.greaterThanOrEqualTo(50)
            make.height.greaterThanOrEqualTo(20)
            make.left.equalTo(self.restaurantNameLabel)
            make.top.equalTo(self.restaurantNameLabel.snp_bottom).offset(16)
        }
        
        // 値段ラベル
        priceLabel.text = Utils.formatPriceString(self.priceRange)
        priceLabel.numberOfLines = 2
        priceLabel.sizeToFit()
        priceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        priceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        self.contentView.addSubview(priceLabel)
        
        self.priceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.restaurantNameLabel)
            make.top.equalTo(categoryLabelView.snp_bottom).offset(TEXT_MARGIN_Y)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 距離ラベル
        distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), self.distance.meterToMinutes())
        distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = UIColor(red: 108/255.0, green: 108/255.0, blue: 108/255.0, alpha: 1.0)
        self.contentView.addSubview(distanceLabel)
        
        self.distanceLabel.snp_makeConstraints { (make) in
            make.top.equalTo(priceLabel.snp_bottom).offset(16)
            make.left.equalTo(restaurantNameLabel)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // separator
        let separator = UIView(frame: CGRectZero)
        separator.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        self.contentView.addSubview(separator)
        separator.snp_makeConstraints { (make) in
            make.top.equalTo(distanceLabel.snp_bottom).offset(14)
            make.left.equalTo(self.contentView)
            make.width.equalTo(self.contentView)
            make.height.equalTo(1.0)
        }
        
        // レビューアイコン
        let reviewIcon = UIImageView(image: UIImage(named: "second"))
        self.contentView.addSubview(reviewIcon)
        reviewIcon.snp_makeConstraints { (make) in
            make.top.equalTo(separator.snp_bottom).offset(12)
            make.left.equalTo(self.restaurantNameLabel)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        // レビューコメント
        let reviewCommentView = UIView(frame: CGRectZero)
        reviewCommentView.backgroundColor = Const.KARUTA_THEME_COLOR
        reviewCommentView.layer.cornerRadius = CORNER_RADIUS
        reviewCommentView.layer.masksToBounds = true
        self.contentView.addSubview(reviewCommentView)
        reviewCommentView.snp_makeConstraints { (make) in
            make.top.equalTo(reviewIcon)
            make.left.equalTo(reviewIcon.snp_right).offset(12)
            make.right.equalTo(self.contentView).offset(-16)
            make.height.equalTo(reviewIcon)
        }
        let reviewCommentLabel = UILabel(frame: CGRectZero)
        reviewCommentLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        reviewCommentLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
        reviewCommentLabel.text = "testてすとテストやで"
        reviewCommentView.addSubview(reviewCommentLabel)
        reviewCommentLabel.snp_makeConstraints { (make) in
            make.top.equalTo(reviewCommentView)
            make.left.equalTo(reviewCommentView).offset(12)
            make.size.equalTo(reviewCommentView)
        }
        
        // もっと見るボタン
        let detailButton = UIButton(frame: CGRectZero)
        detailButton.backgroundColor = Const.RANKING_TOP_COLOR
        detailButton.addTarget(self, action: "resultTapped:", forControlEvents: .TouchUpInside)
        self.contentView.addSubview(detailButton)
        detailButton.snp_makeConstraints { (make) in
            make.top.equalTo(reviewCommentView.snp_bottom).offset(12)
            make.left.equalTo(self.contentView)
            make.width.equalTo(self.contentView)
            make.height.equalTo(44)
            make.bottom.equalTo(self.contentView)
        }
        
        let detailButtonLabel = UILabel(frame: CGRectZero)
        detailButtonLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        detailButtonLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
        detailButtonLabel.textAlignment = .Center
        detailButtonLabel.text = NSLocalizedString("ResultShowDetail", comment: "")
        detailButton.addSubview(detailButtonLabel)
        detailButtonLabel.snp_makeConstraints { (make) in
            make.top.equalTo(detailButton)
            make.left.equalTo(detailButton)
            make.size.equalTo(detailButton)
        }
        
        let arrowLabel = UILabel(frame: CGRectZero)
        arrowLabel.text = ">"
        arrowLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        arrowLabel.numberOfLines = 1
        arrowLabel.sizeToFit()
        arrowLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
        detailButton.addSubview(arrowLabel)
        
        arrowLabel.snp_makeConstraints { (make) in
            make.right.equalTo(detailButton).inset(8)
            make.centerY.equalTo(detailButton)
        }
        
        // 画像のダウンロード
        self.acquireImages()
    }
    
    private func acquireImages() {
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
    
    func resultTapped(sender: AnyObject) {
        self.delegate.detailButtonTapped(self)
    }
}
