//
//  CardView.swift
//  Pecomy
//
//  Created by Kenzo on 2015/07/04.
//  Copyright (c) 2016年 Pecomy. All rights reserved.
//

import UIKit
import SDWebImage
import MDCSwipeToChoose
import SnapKit

protocol CardViewDelegate {
    func blackListButtonTapped(card: CardView, shopID: String)
}

class CardView: MDCSwipeToChooseView {
    
    let NUM_OF_IMAGES = 1
    
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
            let imageView = UIImageView(image: R.image.noimage())
            imageView.contentMode = .ScaleAspectFill
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
        for i in 0..<NUM_OF_IMAGES {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        self.restaurantImageViews[0].snp_makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        
        #if !RELEASE
        // ブラックリストボタン(Releaseバージョンには乗せない)
        self.blackListButton.setImage(R.image.nogood_normal(), forState: .Normal)
        self.blackListButton.setImage(R.image.nogood_tapped(), forState: .Highlighted)
        self.blackListButton.setImage(R.image.nogood_highlighted(), forState: .Disabled)
        self.blackListButton.addTarget(self, action: #selector(CardView.blackListButtonTapped), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(self.blackListButton)
        
        self.blackListButton.snp_makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.right.equalTo(self.contentView).offset(-10)
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
            guard let strongSelf = self else {
                return
            }
            if (state.direction == .None) {
                strongSelf.likedView.alpha = 0.0
                strongSelf.likedLabelView.alpha = 0.0
                strongSelf.nopeView.alpha = 0.0
                strongSelf.nopeLabelView.alpha = 0.0
            } else if (state.direction == .Left) {
                strongSelf.likedView.alpha = 0.0
                strongSelf.likedLabelView.alpha = 0.0
                strongSelf.nopeView.alpha = state.thresholdRatio/2
                strongSelf.nopeLabelView.alpha = state.thresholdRatio
            } else if (state.direction == .Right) {
                strongSelf.likedView.alpha = state.thresholdRatio/2
                strongSelf.likedLabelView.alpha = state.thresholdRatio
                strongSelf.nopeView.alpha = 0.0
                strongSelf.nopeLabelView.alpha = 0.0
            }
            
            if ((strongSelf.options.onPan) != nil) {
                strongSelf.options.onPan(state);
            }
        }
        self.mdc_swipeToChooseSetup(options)
    }
}
