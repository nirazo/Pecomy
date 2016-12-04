//
//  CommentContentView.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class CommentContentView: UIView {

    
    var imageView = UIImageView()
    var commentBackGroundView = UIView()
    var comment = ""
    let contentView = UIView()
    var commentLabel = UILabel()
    var commentBgColor = UIColor.white
    var commentTextColor = Const.PECOMY_RANK_COLOR[0]
    
    init(frame: CGRect, comment: String, backgroundColor: UIColor = UIColor.white, textColor: UIColor = Const.PECOMY_RANK_COLOR[0]) {
        super.init(frame: frame)
        
        self.comment = comment
        self.commentBgColor = backgroundColor
        self.commentTextColor = textColor
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.layer.masksToBounds = true
        
        self.addSubview(contentView)
        
        self.backgroundColor = UIColor.clear
        self.layer.masksToBounds = false
        
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupSubViews() {
                
        self.contentView.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        
        self.imageView.image = self.pickCommentIcon()
        self.imageView.contentMode = .scaleAspectFill
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
        self.commentLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 15)
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
    
    fileprivate func pickCommentIcon() -> UIImage {
        let n = arc4random() % 10 + 1
        return UIImage(named: "comment_human\(n)")!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
