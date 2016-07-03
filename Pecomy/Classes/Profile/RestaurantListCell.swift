//
//  RestaurantListCell.swift
//  Pecomy
//
//  Created by Kenzo on 7/2/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class RestaurantListCell: UITableViewCell {
    var restaurant = Restaurant()
    var restaurantImageView = UIImageView()
    var titleLabel = UILabel()
    var priceLabel = UILabel()
    var genreLabel = CategoryLabelView(frame: .zero, category: "")
    var checkinIcon = UIImageView()
    var favoriteIcon = UIImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.contentView.addSubview(self.restaurantImageView)
        self.restaurantImageView.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(24)
            make.width.equalTo(70)
            make.height.equalTo(70)
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-20)
        }
        
        // 店舗名ラベル
        self.titleLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 16)
        self.titleLabel.textColor = Const.PECOMY_THEME_COLOR
        self.titleLabel.numberOfLines = 2
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp_makeConstraints { make in
            make.top.equalTo(self.restaurantImageView)
            make.left.equalTo(self.restaurantImageView.snp_right).offset(10)
            make.width.equalTo(192.5)
        }

        
        // ジャンルラベル
        self.contentView.addSubview(self.genreLabel)
        self.genreLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel)
            make.left.greaterThanOrEqualTo(self.titleLabel.snp_right).offset(20.5)
            make.right.equalTo(self.contentView).offset(-20)
        }
        
        
        // 価格ラベル
        self.priceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        self.priceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.priceLabel.numberOfLines = 0
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(24.3)
            make.left.equalTo(self.titleLabel)
            make.width.equalTo(192.5)
            make.bottom.greaterThanOrEqualTo(self.contentView).offset(-18.5)
        }

    }
    
    func configureCell(restaurant: Restaurant) {
        self.setupSubviews()
        self.restaurant = restaurant
        self.restaurantImageView.sd_setImageWithURL(NSURL(string: self.restaurant.imageUrls[0]))
        self.restaurantImageView.backgroundColor = .redColor()

        self.titleLabel.text = self.restaurant.shopName
        
        self.genreLabel.setCategory(self.restaurant.category)
        

        self.priceLabel.text = self.restaurant.businessHours
    }
}