//
//  CardView.swift
//  Pecomy
//
//  Created by Kenzo on 2015/07/04.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit
import MDCSwipeToChoose
import SnapKit

protocol CardViewDelegate {
    func blackListButtonTapped(_ card: CardView, shopID: Int)
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
        options.likedText = R.string.localizable.cardLikeText()
        options.likedColor = Const.CARD_LIKE_COLOR
        options.nopeText = R.string.localizable.cardDislikeText()
        options.nopeColor = Const.CARD_DISLIKE_COLOR
        
        self.restaurant = restaurant
        self.syncID = syncID
        
        for _ in 0..<self.NUM_OF_IMAGES {
            let imageView = UIImageView(image: R.image.noimage())
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.backgroundColor = Const.PECOMY_CARD_IMAGE_BACK_COLOR
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
        self.constructLikedView()

        // dislikeのビュー
        self.constructNopeView()

        // SwipeToChooseの再セットアップ
        self.setupSwipeToChoose()
        
        // ドロップシャドウ
        self.shadow.frame = self.bounds
        shadow.layer.masksToBounds = false
        self.insertSubview(self.shadow, at: 0)
        shadow.backgroundColor = UIColor.white
        shadow.layer.cornerRadius = 5.0
        shadow.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
        shadow.layer.shadowRadius = 0.7
        shadow.layer.shadowColor = UIColor.gray.cgColor
        shadow.layer.shadowOpacity = 0.9
        
        // パーツ群を置くビュー
        self.contentView = UIView(frame: self.bounds)
        self.contentView.backgroundColor = UIColor.white
        
        self.contentView.layer.cornerRadius = 5.0
        self.contentView.layer.masksToBounds = true
        
        self.insertSubview(self.contentView, at: 1)
        
        // 画像
        for i in 0..<NUM_OF_IMAGES {
            self.contentView.addSubview(self.restaurantImageViews[i])
        }
        self.restaurantImageViews[0].snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        
        #if !RELEASE
        // ブラックリストボタン(Releaseバージョンには乗せない)
        self.blackListButton.setImage(R.image.nogood_normal(), for: .normal)
        self.blackListButton.setImage(R.image.nogood_tapped(), for: .highlighted)
        self.blackListButton.setImage(R.image.nogood_highlighted(), for: .disabled)
        self.blackListButton.addTarget(self, action: #selector(CardView.blackListButtonTapped), for: .touchUpInside)
        self.contentView.addSubview(self.blackListButton)
        
        self.blackListButton.snp.makeConstraints { (make) in
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
        guard let restaurant = self.restaurant else { return }
        let loopCount = restaurant.imageUrls.count < NUM_OF_IMAGES ? restaurant.imageUrls.count: NUM_OF_IMAGES
        for i in 0..<loopCount {
            let loadingIndicator = UIActivityIndicatorView()
            loadingIndicator.activityIndicatorViewStyle = .whiteLarge
            loadingIndicator.hidesWhenStopped = true
            self.restaurantImageViews[i].addSubview(loadingIndicator)
            loadingIndicator.snp.makeConstraints { make in
                make.center.equalTo(self.restaurantImageViews[i])
                make.width.height.equalTo(50)
            }
            loadingIndicator.startAnimating()
            self.restaurantImageViews[i].kf.setImage(with: URL(string: restaurant.imageUrls[i]), placeholder: nil, options: nil, progressBlock: nil) { [weak self] (image, error, imageCacheType, imageUrl) in
                guard let strongSelf = self else { return }
                strongSelf.restaurantImageViews[i].alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0.0, options:  [.curveEaseIn, .curveEaseOut], animations: {() -> Void in
                    strongSelf.restaurantImageViews[i].contentMode = .scaleAspectFill
                    strongSelf.restaurantImageViews[i].alpha = 1
                }, completion: nil)
                loadingIndicator.stopAnimating()
            }
        }
    }
    
    func blackListButtonTapped() {
        self.delegate?.blackListButtonTapped(self, shopID: self.restaurant!.shopID)
    }
    
    
    // 「行きたい」の時にかぶせるビュー
    func constructLikedView() {
        if let likedView = self.likedView {
            likedView.removeFromSuperview()
        }
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        likedView = UIView(frame: frame)
        likedView.backgroundColor = UIColor(red: 230.0/255.0, green: 77.0/255.0, blue: 74.0/255.0, alpha:1.0)
        likedView.alpha = 0.0
        likedView.layer.cornerRadius = 5.0
        self.addSubview(likedView)
        
        self.likedLabelView = CardOverlayTextLabelView(
            frame: CGRect(x: MDCSwipeToChooseViewHorizontalPadding,
                y: MDCSwipeToChooseViewTopPadding,
                width: self.bounds.midX,
                height: MDCSwipeToChooseViewLabelHeight),
            text: self.options.likedText)
        
        self.likedLabelView.alpha = 0.0
        self.addSubview(self.likedLabelView)

        self.likedLabelView.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double(self.options.likedRotationAngle)*(M_PI/180.0)))
    }
    
    // 「イマイチ」の時にかぶせるビュー
    func constructNopeView() {
        self.nopeView.removeFromSuperview()
        let frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.nopeView = UIView(frame: frame)
        self.nopeView.backgroundColor = UIColor(red: 75.0/255.0, green: 140.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        self.nopeView.alpha = 0.0
        self.nopeView.layer.cornerRadius = 5.0
        self.addSubview(self.nopeView)
        
        
        let width = self.bounds.midX;
        let xOrigin = self.bounds.maxX - width - MDCSwipeToChooseViewHorizontalPadding
        
        self.nopeLabelView = CardOverlayTextLabelView(frame: CGRect(
            x: xOrigin,
            y: MDCSwipeToChooseViewTopPadding,
            width: self.bounds.midX,
            height: MDCSwipeToChooseViewLabelHeight),
            text: self.options.nopeText)
        
        self.nopeLabelView.alpha = 0.0
        self.addSubview(self.nopeLabelView)
        
        self.nopeLabelView.transform = CGAffineTransform.identity.rotated(by: CGFloat(Double(self.options.nopeRotationAngle)*(M_PI/180.0)))
    }
    
    
    //setup
    fileprivate func setupSwipeToChoose() {
        let options = MDCSwipeOptions()
        options.delegate = self.options.delegate
        options.threshold = self.options.threshold
        options.onPan = { [weak self] (state) in
            guard let strongSelf = self else { return }
            if (state?.direction == MDCSwipeDirection.none) {
                strongSelf.likedView.alpha = 0.0
                strongSelf.likedLabelView.alpha = 0.0
                strongSelf.nopeView.alpha = 0.0
                strongSelf.nopeLabelView.alpha = 0.0
            } else if (state?.direction == .left) {
                strongSelf.likedView.alpha = 0.0
                strongSelf.likedLabelView.alpha = 0.0
                strongSelf.nopeView.alpha = (state?.thresholdRatio)!/2
                strongSelf.nopeLabelView.alpha = (state?.thresholdRatio)!
            } else if (state?.direction == .right) {
                strongSelf.likedView.alpha = (state?.thresholdRatio)!/2
                strongSelf.likedLabelView.alpha = (state?.thresholdRatio)!
                strongSelf.nopeView.alpha = 0.0
                strongSelf.nopeLabelView.alpha = 0.0
            }
            
            if let pan = strongSelf.options.onPan {
                pan(state);
            }
        }
        self.mdc_swipe(toChooseSetup: options)
    }
}
