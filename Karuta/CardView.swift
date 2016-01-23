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
    
    let MDCSwipeToChooseViewHorizontalPadding: CGFloat = 13.0
    let MDCSwipeToChooseViewTopPadding: CGFloat = 25.0
    let MDCSwipeToChooseViewLabelHeight: CGFloat = 65.0
    
    var delegate: CardViewDelegate?
    
    var restaurant: Restaurant?
    
    var contentView = UIView()
    var shadow = UIView()
    
    var syncID = ""
    var restaurantImageViews = [UIImageView]()
    let blackListButton = UIButton()
    
    var options = MDCSwipeToChooseViewOptions()
    
    var likedLabelView = UIView()
    var nopeLabelView = UIView()
    
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
        self.options = options
        
        self.setupSubViews()

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        
        self.layer.masksToBounds = false
        self.layer.borderWidth = 0.0
        
        // likeのビュー
        self.constructLikedVieww()

        // dislikeのビュー
        self.constructNopeView()

        // SwipeToChooseの再セットアップ
        self.setupSwipeToChoose()
        
        // ドロップシャドウ
        self.shadow.frame = self.bounds
        shadow.layer.masksToBounds = false
        self.insertSubview(self.shadow, atIndex: 0)
        shadow.backgroundColor = UIColor.whiteColor()
        shadow.layer.cornerRadius = 5.0
        shadow.layer.shadowOffset = CGSizeMake(0.5, 1.0)
        shadow.layer.shadowRadius = 0.7
        shadow.layer.shadowColor = UIColor.grayColor().CGColor
        shadow.layer.shadowOpacity = 0.9
        
        // パーツ群を置くビュー
        self.contentView = UIView(frame: self.bounds)
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        
        self.insertSubview(self.contentView, atIndex: 1)
        
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
    
    
    // 「行きたい」の時にかぶせるビュー
    func constructLikedVieww() {

        self.likedView.removeFromSuperview()
        let frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.likedView = UIView(frame: frame)
        self.likedView.backgroundColor = UIColor(red: 230.0/255.0, green: 77.0/255.0, blue: 74.0/255.0, alpha:1.0)
        self.likedView.alpha = 0.0
        self.likedView.layer.cornerRadius = 5.0
        self.addSubview(self.likedView)
        
        self.likedLabelView = CardOverlayTextLabelView(
            frame: CGRect(x: MDCSwipeToChooseViewHorizontalPadding,
                y: MDCSwipeToChooseViewTopPadding,
                width: CGRectGetMidX(self.bounds),
                height: MDCSwipeToChooseViewLabelHeight),
            text: self.options.likedText)
        
        self.likedLabelView.alpha = 0.0
        self.addSubview(self.likedLabelView)

        self.likedLabelView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(Double(self.options.likedRotationAngle)*(M_PI/180.0)))
    }
    
    // 「イマイチ」の時にかぶせるビュー
    func constructNopeView() {
        self.nopeView.removeFromSuperview()
        let frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
        self.nopeView = UIView(frame: frame)
        self.nopeView.backgroundColor = UIColor(red: 75.0/255.0, green: 140.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        self.nopeView.alpha = 0.0
        self.nopeView.layer.cornerRadius = 5.0
        self.addSubview(self.nopeView)
        
        
        let width = CGRectGetMidX(self.bounds);
        let xOrigin = CGRectGetMaxX(self.bounds) - width - MDCSwipeToChooseViewHorizontalPadding
        
        self.nopeLabelView = CardOverlayTextLabelView(frame: CGRect(
            x: xOrigin,
            y: MDCSwipeToChooseViewTopPadding,
            width: CGRectGetMidX(self.bounds),
            height: MDCSwipeToChooseViewLabelHeight),
            text: self.options.nopeText)
        
        self.nopeLabelView.alpha = 0.0
        self.addSubview(self.nopeLabelView)
        
        self.nopeLabelView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, CGFloat(Double(self.options.nopeRotationAngle)*(M_PI/180.0)))
    }
    
    
    //setup
    private func setupSwipeToChoose() {
        let options = MDCSwipeOptions()
        options.delegate = self.options.delegate
        options.threshold = self.options.threshold
        
        options.onPan = { [weak self] (state) in
            guard let weakSelf = self else {
                return
            }
            if (state.direction == .None) {
                weakSelf.likedView.alpha = 0.0
                weakSelf.likedLabelView.alpha = 0.0
                weakSelf.nopeView.alpha = 0.0
                weakSelf.nopeLabelView.alpha = 0.0
            } else if (state.direction == .Left) {
                weakSelf.likedView.alpha = 0.0
                weakSelf.likedLabelView.alpha = 0.0
                weakSelf.nopeView.alpha = state.thresholdRatio/2
                weakSelf.nopeLabelView.alpha = state.thresholdRatio
            } else if (state.direction == .Right) {
                weakSelf.likedView.alpha = state.thresholdRatio/2
                weakSelf.likedLabelView.alpha = state.thresholdRatio
                weakSelf.nopeView.alpha = 0.0
                weakSelf.nopeLabelView.alpha = 0.0
            }
            
            if ((weakSelf.options.onPan) != nil) {
                weakSelf.options.onPan(state);
            }
        }
        self.mdc_swipeToChooseSetup(options)
    }
}
