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
    var timestampLabel = UILabel()
    var cellType: RestaurantListType = .None
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        self.restaurantImageView.contentMode = .Redraw
        self.contentView.addSubview(self.restaurantImageView)
        self.restaurantImageView.snp_makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(24)
            make.width.height.equalTo(self.contentView.snp_width).dividedBy(4.5)
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
        }

        
        // ジャンルラベル
        self.contentView.addSubview(self.genreLabel)
        self.genreLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel)
            make.left.greaterThanOrEqualTo(self.titleLabel.snp_right).offset(20)
            make.left.lessThanOrEqualTo(self.titleLabel.snp_right).offset(40)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        
        // 価格ラベル
        self.priceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        self.priceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.priceLabel.numberOfLines = 0
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.snp_makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(24.3)
            make.left.equalTo(self.titleLabel)
            //make.width.equalTo(self.titleLabel)
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-25)
        }
        
        // チェックイン
        self.checkinIcon.image = R.image.cell_checkin_off()
        self.contentView.addSubview(self.checkinIcon)
        self.checkinIcon.snp_makeConstraints { make in
            make.left.equalTo(self.priceLabel.snp_right).offset(11)
            make.bottom.equalTo(self.restaurantImageView)
            make.width.height.equalTo(26)
        }
        
        // お気に入り
        self.favoriteIcon.image = R.image.cell_favorite_off()
        self.contentView.addSubview(self.favoriteIcon)
        self.favoriteIcon.snp_makeConstraints { make in
            make.left.equalTo(self.checkinIcon.snp_right).offset(7)
            make.right.equalTo(self.genreLabel)
            make.bottom.equalTo(self.restaurantImageView)
            make.width.height.equalTo(26)
        }
        
        // 時刻ラベル
        self.timestampLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 10)
        self.timestampLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.timestampLabel.numberOfLines = 0
        self.contentView.addSubview(self.timestampLabel)
        self.timestampLabel.snp_makeConstraints { make in
            make.top.greaterThanOrEqualTo(self.favoriteIcon.snp_bottom).offset(10)
            make.right.equalTo(self.favoriteIcon.snp_right)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
    }
    
    func configureCell(restaurant: Restaurant, type: RestaurantListType = .None) {
        self.setupSubviews()
        self.cellType = type
        self.restaurant = restaurant
        self.restaurantImageView.sd_setImageWithURL(NSURL(string: self.restaurant.imageUrls[0]))
        self.titleLabel.text = self.restaurant.shopName
        self.genreLabel.setCategory(self.restaurant.category)
        
        if (self.restaurant.visits > 0 || type == .Visits) {
            self.checkinIcon.image = R.image.cell_checkin_on()
        } else {
            self.checkinIcon.image = R.image.cell_checkin_off()
        }
        
        if (self.restaurant.favorite || type == .Favorites) {
            self.favoriteIcon.image = R.image.cell_favorite_on()
        } else {
            self.favoriteIcon.image = R.image.cell_favorite_off()
        }
        
        if (self.cellType != .None) {
            self.timestampLabel.text = String(format: NSLocalizedString("RegisteredTime", comment: ""), Utils.dateStringToTimeString(self.restaurant.timestamp))
        }
        
        self.priceLabel.text = (self.restaurant.dayPriceRange.isEmpty ? "" : self.restaurant.dayPriceRange + "\n") + self.restaurant.nightPriceRange
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.alpha = 0.5
        } else {
            self.alpha = 1.0
        }
    }
}