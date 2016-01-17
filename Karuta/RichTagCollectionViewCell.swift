//
//  RichTagCollectionViewCell.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class RichTagCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView
    var categoryLabel: UILabel
    var richTag = RichTag(rawValue: "なし") {
        didSet {
            self.imageView.image = self.richTag!.imageForTag()
            self.categoryLabel.text = self.richTag!.rawValue
        }
    }
    
    override init(frame: CGRect) {
        self.imageView = UIImageView(frame: frame)
        self.categoryLabel = UILabel(frame: frame)
        self.categoryLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.categoryLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 13)
        super.init(frame: frame)
        self.contentView.addSubview(self.imageView)
        self.contentView.addSubview(self.categoryLabel)
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.imageView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(32)
            make.height.equalTo(32)
        }
        self.categoryLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.imageView.snp_right).offset(8)
            make.height.equalTo(self)
            make.top.equalTo(self)
            make.right.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
