//
//  CommentContentView.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class CommentContentView: UIView {

    
    var imageView = UIImageView(image: UIImage(named: "comment_human"))
    var commentBackGroundView = UIView()
    var comment = ""
    let contentView = UIView()
    var commentLabel = UILabel()
    var commentBgColor = UIColor.whiteColor()
    var commentTextColor = Const.KARUTA_RANK_COLOR[0]
    
    init(frame: CGRect, comment: String, backgroundColor: UIColor = UIColor.whiteColor(), textColor: UIColor = Const.KARUTA_RANK_COLOR[0]) {
        super.init(frame: frame)
        
        self.comment = comment
        self.commentBgColor = backgroundColor
        self.commentTextColor = textColor
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.clearColor()
        self.contentView.layer.masksToBounds = true
        
        self.addSubview(contentView)
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.masksToBounds = false
        
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubViews() {
                
        self.contentView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.imageView.contentMode = .ScaleAspectFill
        self.imageView.clipsToBounds = true
        self.contentView.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { (make) in
            make.width.equalTo(40)
            make.height.equalTo(40)
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
        
        // コメントビュー
        self.commentBackGroundView.layer.cornerRadius = 5.0
        self.commentBackGroundView.layer.masksToBounds = true
        self.commentBackGroundView.backgroundColor = self.commentBgColor
        self.addSubview(self.commentBackGroundView)
        self.commentBackGroundView.snp_makeConstraints { (make) in
            make.height.equalTo(40)
            make.left.equalTo(self.imageView.snp_right).offset(12)
            make.top.equalTo(self)
            make.right.lessThanOrEqualTo(self).offset(-12)
            make.bottom.equalTo(self)
        }
        
        // コメント
        self.commentLabel.text = self.comment
        self.commentLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 15)
        self.commentLabel.textColor = self.commentTextColor
        self.commentLabel.numberOfLines = 2
        self.commentLabel.sizeToFit()
        self.addSubview(self.commentLabel)
        
        self.commentLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.commentBackGroundView).offset(12)
            make.top.equalTo(self.commentBackGroundView)
            make.bottom.equalTo(self.commentBackGroundView)
            make.height.equalTo(self.commentBackGroundView)
            make.right.equalTo(self.commentBackGroundView).offset(-12)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
