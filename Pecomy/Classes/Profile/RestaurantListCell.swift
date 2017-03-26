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
    var cellType: RestaurantListType = .none
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubviews() {
        // サムネ画像
        self.restaurantImageView.contentMode = .redraw
        self.contentView.addSubview(self.restaurantImageView)
        self.restaurantImageView.snp.makeConstraints { make in
            make.left.equalTo(self.contentView).offset(15)
            make.top.equalTo(self.contentView).offset(24)
            make.width.height.equalTo(self.contentView.snp.width).dividedBy(4.5)
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-20)
        }
        
        // 店舗名ラベル
        self.titleLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 16)
        self.titleLabel.textColor = Const.PECOMY_THEME_COLOR
        self.titleLabel.numberOfLines = 2
        self.contentView.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(self.restaurantImageView)
            make.left.equalTo(self.restaurantImageView.snp.right).offset(10)
            make.right.equalTo(self.contentView).offset(-80)
        }

        
        // ジャンルラベル
        self.contentView.addSubview(self.genreLabel)
        self.genreLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel)
            make.left.equalTo(self.titleLabel.snp.right).offset(6)
            make.right.equalTo(self.contentView).offset(-15)
        }
        
        // 価格ラベル
        self.priceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        self.priceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.priceLabel.numberOfLines = 0
        self.contentView.addSubview(self.priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(self.titleLabel.snp.bottom).offset(24.3)
            make.left.equalTo(self.titleLabel)
            make.bottom.lessThanOrEqualTo(self.contentView).offset(-25)
        }
        
        // チェックイン
        self.checkinIcon.image = R.image.cell_checkin_off()
        self.contentView.addSubview(self.checkinIcon)
        self.checkinIcon.snp.makeConstraints { make in
            make.left.equalTo(self.priceLabel.snp.right).offset(11)
            make.bottom.equalTo(self.restaurantImageView)
            make.width.height.equalTo(26)
        }
        
        // お気に入り
        self.favoriteIcon.image = R.image.cell_favorite_off()
        self.contentView.addSubview(self.favoriteIcon)
        self.favoriteIcon.snp.makeConstraints { make in
            make.left.equalTo(self.checkinIcon.snp.right).offset(7)
            make.right.equalTo(self.genreLabel)
            make.bottom.equalTo(self.restaurantImageView)
            make.width.height.equalTo(26)
        }
        
        // 時刻ラベル
        self.timestampLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 10)
        self.timestampLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.timestampLabel.numberOfLines = 0
        self.contentView.addSubview(self.timestampLabel)
        self.timestampLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(self.favoriteIcon.snp.bottom).offset(10)
            make.right.equalTo(self.favoriteIcon.snp.right)
            make.bottom.equalTo(self.contentView).offset(-12)
        }
    }
    
    func configureCell(_ restaurant: Restaurant, type: RestaurantListType = .none) {
        self.setupSubviews()
        self.cellType = type
        self.restaurant = restaurant
        self.restaurantImageView.kf.setImage(with: URL(string: self.restaurant.imageUrls[0]), placeholder: nil, options: nil, progressBlock: nil) { [weak self] (image, error, imageCacheType, imageURL) in
            guard let strongSelf = self else { return }
            strongSelf.restaurantImageView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                strongSelf.restaurantImageView.alpha = 1
            }, completion: nil)
        }
        self.titleLabel.text = self.restaurant.shopName
        self.genreLabel.setCategory(self.restaurant.category)
        
        if (self.restaurant.visits > 0 || type == .visits) {
            self.checkinIcon.image = R.image.cell_checkin_on()
        } else {
            self.checkinIcon.image = R.image.cell_checkin_off()
        }
        
        if (self.restaurant.favorite || type == .favorites) {
            self.favoriteIcon.image = R.image.cell_favorite_on()
        } else {
            self.favoriteIcon.image = R.image.cell_favorite_off()
        }
        
        if (self.cellType != .none) {
            self.timestampLabel.text = String(format: NSLocalizedString("RegisteredTime", comment: ""), Utils.dateStringToTimeString(self.restaurant.timestamp))
        }
        
        self.priceLabel.text = (self.restaurant.dayPriceRange.isEmpty ? "" : self.restaurant.dayPriceRange + "\n") + self.restaurant.nightPriceRange
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if (highlighted) {
            self.alpha = 0.5
        } else {
            self.alpha = 1.0
        }
    }
}
