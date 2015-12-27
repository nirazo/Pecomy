//
//  OtherResultCard.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage

class OtherResultsCard: UIView {
    
    private let shadow = UIView()
    let contentView = UIView()
    private let CORNER_RADIUS: CGFloat = 5.0
    
    // 描画系定数
    private let NUM_OF_IMAGES = 1
    private let TEXT_MARGIN_X: CGFloat = 10.0
    private let TEXT_MARGIN_Y: CGFloat = 5.0
    private let SEPARATOR_WIDTH: CGFloat = 1.0
    
    var restaurants = [Restaurant]()
    var restaurantsCards = [OtherResultCardContentView]()
    
    init(frame: CGRect, restaurants: [Restaurant],  delegate: ResultCardBaseDelegate) {
        super.init(frame: frame)
        
        self.restaurants = restaurants
        
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
        
        self.addSubview(contentView)

        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.masksToBounds = false
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        self.contentView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        self.contentView.layer.frame = self.contentView.bounds
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.shadow.snp_makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        self.shadow.layer.frame = self.shadow.bounds
        
        for (var i = 0; i < self.restaurants.count; i++)  {
            let content = OtherResultCardContentView(frame: CGRectZero, restaurant: self.restaurants[i])
            self.restaurantsCards.append(content)
            self.contentView.addSubview(self.restaurantsCards[i])
            self.restaurantsCards[i].snp_makeConstraints { (make) in
                make.left.equalTo(self.contentView)
                make.width.equalTo(self.contentView)
                if i == 0 {
                    make.top.equalTo(self.contentView)
                } else {
                    make.top.equalTo(self.restaurantsCards[i-1].snp_bottom).offset(self.SEPARATOR_WIDTH)
                }
                if i == self.restaurants.count-1 {
                    make.bottom.equalTo(self.contentView)
                }
            }
            if (i != self.restaurants.count-1) {
                // separator
                let separator = UIView(frame: CGRectZero)
                separator.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                self.contentView.addSubview(separator)
                separator.snp_makeConstraints { (make) in
                    make.top.equalTo(self.restaurantsCards[i].snp_bottom).offset(0)
                    make.left.equalTo(self.contentView)
                    make.width.equalTo(self.contentView)
                    make.height.equalTo(self.SEPARATOR_WIDTH)
                }
            }
        }
    }
}
