//
//  ResultViewCell.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/12.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

class ResultViewCell: UITableViewCell {
    
    let IMAGE_WIDTH = 120;
    let IMAGE_HEIGHT = 105;
    let CORNER_RADIUS: CGFloat = 5.0;

    var titleLabel = UILabel()
    var numberLabel = UILabel()
    var pictureView = UIImageView()
    var restaurantNameLabel = UILabel()
    var categoryLabel = UILabel()
    var priceMinLabel = UILabel()
    var priceMaxLabel = UILabel()
    var distantLabel = UILabel()
    var shopUrl = NSURL()
    var cellView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // 各パーツを配備するビュー
        self.cellView = UIView()
        self.contentView.addSubview(self.cellView)
        
        // 順位
        self.numberLabel = UILabel()
        self.numberLabel.textAlignment = .Center
        self.numberLabel.backgroundColor = Const.KARUTA_THEME_COLOR
        self.numberLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
        self.numberLabel.clipsToBounds = true
        self.cellView.addSubview(self.numberLabel)
        
        // 店舗画像
        self.pictureView = UIImageView()
        self.pictureView.backgroundColor = UIColor.blueColor()
        self.pictureView.contentMode = UIViewContentMode.ScaleAspectFill
        self.pictureView.clipsToBounds = true
        self.cellView.addSubview(self.pictureView)
        
        // 店名
        self.titleLabel = UILabel()
        self.titleLabel.autoresizingMask = .FlexibleWidth
        self.titleLabel.font = UIFont.systemFontOfSize(12)
        self.titleLabel.numberOfLines = 1
        self.cellView.addSubview(self.titleLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func drawRect(rect: CGRect) {
        self.cellView.backgroundColor = UIColor.whiteColor()
        self.cellView.snp_makeConstraints { (make) in
            make.height.equalTo(self.contentView).multipliedBy(0.9)
            make.width.equalTo(self.contentView).multipliedBy(0.96)
            make.center.equalTo(self.contentView)
        }
        self.numberLabel.snp_makeConstraints { (make) in
            make.width.equalTo(self.cellView).multipliedBy(0.4)
            make.height.equalTo(self.cellView).multipliedBy(0.15)
            make.top.equalTo(self.cellView)
            make.left.equalTo(self.cellView)
        }
        self.pictureView.snp_makeConstraints { (make) in
            make.width.equalTo(self.numberLabel)
            make.height.equalTo(self.cellView).offset(-self.numberLabel.frame.height)
            make.top.equalTo(self.numberLabel.snp_bottom)
            make.left.equalTo(self.cellView)
        }
        self.titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.cellView).offset(10)
            make.right.equalTo(self.numberLabel.snp_right).offset(5)
            make.width.equalTo(self.cellView.frame.width - self.numberLabel.frame.width)
        }
        
        // セルの枠線
        self.cellView.layer.borderColor = UIColor.grayColor().CGColor
        self.cellView.layer.borderWidth = 0.8
        self.cellView.layer.cornerRadius = CORNER_RADIUS
        self.cellView.layer.masksToBounds = true
        
        // ドロップシャドウ
        var shadow = UIView()
        shadow.layer.masksToBounds = false
        shadow.layer.cornerRadius = CORNER_RADIUS
        shadow.backgroundColor = UIColor.whiteColor()
        shadow.layer.shadowOffset = CGSizeMake(0.5, 1.0)
        shadow.layer.shadowRadius = 0.7
        shadow.layer.shadowColor = UIColor.grayColor().CGColor
        shadow.layer.shadowOpacity = 0.9
        self.contentView.addSubview(shadow)
        self.contentView.sendSubviewToBack(shadow)
        shadow.snp_makeConstraints { (make) in
            make.center.equalTo(self.cellView)
            make.width.equalTo(self.cellView)
            make.height.equalTo(self.cellView)
        }
    }
    
    func setRestaurantImage(imageUrl: NSURL) {
        self.pictureView.sd_setImageWithURL(imageUrl, completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
            self?.pictureView.alpha = 0
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() in
                self?.pictureView.alpha = 1
                }, completion: nil)
            })
    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
