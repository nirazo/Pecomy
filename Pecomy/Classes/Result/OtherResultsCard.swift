//
//  OtherResultCard.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit

protocol OtherResultCardDelegate {
    func contentTapped(_ restaurant: Restaurant)
}

class OtherResultsCard: UIView {
    
    fileprivate let shadow = UIView()
    let contentView = UIView()
    fileprivate let CORNER_RADIUS: CGFloat = 5.0
    
    // 描画系定数
    fileprivate let NUM_OF_IMAGES = 1
    fileprivate let TEXT_MARGIN_X: CGFloat = 10.0
    fileprivate let TEXT_MARGIN_Y: CGFloat = 5.0
    fileprivate let SEPARATOR_WIDTH: CGFloat = 1.0
    
    var restaurants = [Restaurant]()
    var restaurantsCards = [OtherResultCardContentView]()
    
    var delegate: OtherResultCardDelegate?
    
    init(frame: CGRect, restaurants: [Restaurant],  delegate: ResultCardBaseDelegate) {
        super.init(frame: frame)
        
        self.restaurants = restaurants
        
        // ドロップシャドウ
        self.shadow.layer.masksToBounds = false
        self.addSubview(shadow)
        self.shadow.backgroundColor = .white
        self.shadow.layer.cornerRadius = CORNER_RADIUS
        self.shadow.layer.shadowOpacity = 0.7
        self.shadow.layer.shadowColor =  UIColor.gray.cgColor
        self.shadow.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = CORNER_RADIUS
        self.contentView.layer.masksToBounds = true
        
        self.addSubview(contentView)

        self.backgroundColor = .white
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.masksToBounds = false
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        self.contentView.snp.makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        self.contentView.layer.frame = self.contentView.bounds
        self.contentView.backgroundColor = .white
        
        self.shadow.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        self.shadow.layer.frame = self.shadow.bounds
        
        for i in 0 ..< self.restaurants.count {
            let content = OtherResultCardContentView(frame: .zero, restaurant: self.restaurants[i])
            content.delegate = self
            self.restaurantsCards.append(content)
            self.contentView.addSubview(self.restaurantsCards[i])
            self.restaurantsCards[i].snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView)
                make.width.equalTo(self.contentView)
                if i == 0 {
                    make.top.equalTo(self.contentView)
                } else {
                    make.top.equalTo(self.restaurantsCards[i-1].snp.bottom).offset(self.SEPARATOR_WIDTH)
                }
                if i == self.restaurants.count-1 {
                    make.bottom.equalTo(self.contentView)
                }
            }
            if (i != self.restaurants.count-1) {
                // separator
                let separator = UIView(frame: .zero)
                separator.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
                self.contentView.addSubview(separator)
                separator.snp.makeConstraints { (make) in
                    make.top.equalTo(self.restaurantsCards[i].snp.bottom).offset(0)
                    make.left.equalTo(self.contentView)
                    make.width.equalTo(self.contentView)
                    make.height.equalTo(self.SEPARATOR_WIDTH)
                }
            }
        }
    }
}

extension OtherResultsCard: OtherResultCardContentDelegate {
    func contentTapped(_ restaurant: Restaurant) {
        self.delegate?.contentTapped(restaurant)
    }
}
