//
//  OtherResultCardContentView.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/25.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import SDWebImage

protocol OtherResultCardContentDelegate {
    func contentTapped(_ restaurant: Restaurant)
}

class OtherResultCardContentView: UIView {
    
    var imageView = UIImageView()
    var restaurant: Restaurant?
    let contentView = UIView()
    var delegate: OtherResultCardContentDelegate?
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame)
        
        self.restaurant = restaurant
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = .white
        self.contentView.layer.masksToBounds = true
        
        self.addSubview(contentView)
        
        self.backgroundColor = .clear
        self.layer.masksToBounds = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(OtherResultCardContentView.tapped))
        self.addGestureRecognizer(tapGesture)
                
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubViews() {
        
        guard let restaurant = self.restaurant else {
            return
        }
        
        self.backgroundColor = .white
        
        self.contentView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { (make) in
            make.width.equalTo(80)
            make.height.equalTo(80)
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        // 店名
        let restaurantNameLabel = UILabel(frame: .zero)
        restaurantNameLabel.text = restaurant.shopName
        restaurantNameLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 14)
        restaurantNameLabel.numberOfLines = 1
        restaurantNameLabel.textColor = Const.RANKING_SECOND_COLOR
        restaurantNameLabel.sizeToFit()
        self.contentView.addSubview(restaurantNameLabel)
        
        restaurantNameLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp_right).offset(12)
            make.top.equalTo(self).offset(14)
            make.height.greaterThanOrEqualTo(14)
            make.right.equalTo(self).offset(-10)
        }
        
        // 距離ラベル
        let distanceLabel = UILabel(frame: .zero)
        distanceLabel.text =  String(format: NSLocalizedString("CardDistanceFromText", comment: ""), Utils.meterToMinutes(restaurant.distance))
        distanceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        distanceLabel.numberOfLines = 0
        distanceLabel.sizeToFit()
        distanceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.contentView.addSubview(distanceLabel)
        
        distanceLabel.snp_makeConstraints { (make) in
            make.left.equalTo(restaurantNameLabel)
            make.bottom.equalTo(self).offset(-14)
            make.height.greaterThanOrEqualTo(12)
            make.width.equalTo(restaurantNameLabel)
        }
        
        // 矢印ラベル
        let arrowLabel = UILabel(frame: .zero)
        arrowLabel.text = ">"
        arrowLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 16)
        arrowLabel.numberOfLines = 1
        arrowLabel.sizeToFit()
        arrowLabel.textColor =  UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        self.contentView.addSubview(arrowLabel)
        
        arrowLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-8)
            make.centerY.equalTo(self.contentView)
        }

        let imageurls = restaurant.imageUrls.flatMap{URL(string: $0)}
        self.acquireImage(imageurls.first!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    fileprivate func acquireImage(_ url: URL?) {
        guard let url = url else {
            self.imageView.image = R.image.noimage()
            return
        }
        self.imageView.sd_setImage(with: url) { [weak self] (image, error, imageCacheType, imageURL) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.imageView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions(), animations: {() -> Void in
                strongSelf.imageView.alpha = 1
                }, completion: nil)
            }
    }
    
    func tapped() {
        self.delegate?.contentTapped(self.restaurant!)
    }
}
