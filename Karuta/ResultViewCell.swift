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
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }

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
        
//        // カテゴリ
//        self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//        self.categoryLabel.font = [UIFont systemFontOfSize:12];
//        //self.categoryLabel.backgroundColor = [UIColor redColor];
//        
//        // 値段（Min, 〜, Max, 円）
//        self.priceMinLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//        self.priceMinLabel.font = [UIFont systemFontOfSize:12];
//        //self.priceMinLabel.backgroundColor = [UIColor blueColor];
//        
//        self.priceConnectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
//        self.priceConnectLabel.text = @"〜";
//        self.priceConnectLabel.textAlignment = NSTextAlignmentCenter;
//        self.priceConnectLabel.font = [UIFont systemFontOfSize:12];
//        //self.priceConnectLabel.backgroundColor = [UIColor redColor];
//        
//        self.priceMaxLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
//        self.priceMaxLabel.font = [UIFont systemFontOfSize:12];
//        //self.priceMaxLabel.backgroundColor = [UIColor blueColor];
//        
//        self.priceYenLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 30)];
//        self.priceYenLabel.text = @"円";
//        self.priceYenLabel.font = [UIFont systemFontOfSize:12];
//        //self.priceMaxLabel.backgroundColor = [UIColor blueColor];
//        
//        // 距離（ここから, xx, m）
//        self.distantPrefixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//        self.distantPrefixLabel.font = [UIFont systemFontOfSize:12];
//        self.distantPrefixLabel.text = @"ここから";
//        //self.distantPrefixLabel.backgroundColor = [UIColor redColor];
//        
//        self.distantLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
//        self.distantLabel.font = [UIFont systemFontOfSize:12];
//        //self.distantLabel.backgroundColor = [UIColor blueColor];
//        
//        self.distantSuffixLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
//        self.distantSuffixLabel.font = [UIFont systemFontOfSize:12];
//        self.distantSuffixLabel.text = @"m";
//        //self.distantSuffixLabel.backgroundColor = [UIColor redColor];
//        
//        [self.cellView addSubview:self.titleLabel];
//        [self.cellView addSubview:self.numberLabel];
//        [self.cellView addSubview:self.pictureView];
//        [self.cellView addSubview:self.restaurantNameLabel];
//        [self.cellView addSubview:self.categoryLabel];
//        [self.cellView addSubview:self.priceMinLabel];
//        [self.cellView addSubview:self.priceConnectLabel];
//        [self.cellView addSubview:self.priceMaxLabel];
//        [self.cellView addSubview:self.priceYenLabel];
//        [self.cellView addSubview:self.distantPrefixLabel];
//        [self.cellView addSubview:self.distantLabel];
//        [self.cellView addSubview:self.distantSuffixLabel];
        
        //self.updateLayout()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateLayout() {
        // セルの枠線
        self.cellView.layer.borderColor = UIColor.grayColor().CGColor
        self.cellView.layer.borderWidth = 0.5
        self.cellView.layer.cornerRadius = CORNER_RADIUS
        self.cellView.layer.masksToBounds = true
        
        // ドロップシャドウ
        self.cellView.layer.masksToBounds = false
        self.cellView.layer.shadowOffset = CGSizeMake(0.5, 1.0)
        self.cellView.layer.shadowOpacity = 0.5
        self.cellView.layer.shadowColor = UIColor.grayColor().CGColor
        self.cellView.layer.shadowRadius = 0.7
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
    
//    - (void)updateLayout {
//
//    self.cellView.frame = CGRectOffset(self.cellView.frame, cornerRadius, cornerRadius);
//    self.cellView.backgroundColor = [UIColor whiteColor];
//    
//    self.numberLabel.frame = CGRectOffset(self.numberLabel.frame, CGRectGetMaxX(self.titleLabel.frame), 0);
//    
//    self.pictureView.frame = CGRectOffset(self.pictureView.frame, cornerRadius, CGRectGetMaxY(self.titleLabel.frame));
//    
//    CGFloat rightSideLabelOriginX = CGRectGetMaxX(self.pictureView.frame) + 20;
//    
//    self.restaurantNameLabel.frame =  CGRectOffset(self.restaurantNameLabel.frame, rightSideLabelOriginX, 0);
//    self.categoryLabel.frame = CGRectOffset(self.categoryLabel.frame, rightSideLabelOriginX, CGRectGetMaxY(self.restaurantNameLabel.frame));
//    self.priceMinLabel.frame = CGRectOffset(self.priceMinLabel.frame, rightSideLabelOriginX, CGRectGetMaxY(self.categoryLabel.frame));
//    self.priceConnectLabel.frame = CGRectOffset(self.priceConnectLabel.frame, CGRectGetMaxX(self.priceMinLabel.frame), CGRectGetMaxY(self.categoryLabel.frame));
//    self.priceMaxLabel.frame = CGRectOffset(self.priceMaxLabel.frame, CGRectGetMaxX(self.priceConnectLabel.frame), CGRectGetMaxY(self.categoryLabel.frame));
//    self.priceYenLabel.frame = CGRectOffset(self.priceYenLabel.frame, CGRectGetMaxX(self.priceMaxLabel.frame), CGRectGetMaxY(self.categoryLabel.frame));
//    self.distantPrefixLabel.frame = CGRectOffset(self.distantPrefixLabel.frame, rightSideLabelOriginX, CGRectGetMaxY(self.priceMinLabel.frame));
//    self.distantLabel.frame = CGRectOffset(self.distantLabel.frame, CGRectGetMaxX(self.distantPrefixLabel.frame), self.distantPrefixLabel.frame.origin.y);
//    self.distantSuffixLabel.frame = CGRectOffset(self.distantSuffixLabel.frame, CGRectGetMaxX(self.distantLabel.frame), self.distantPrefixLabel.frame.origin.y);
//    
   
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
