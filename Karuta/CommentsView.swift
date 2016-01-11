//
//  CommentsView.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class CommentsView: UIView {
    
    let contentView = UIView()
    
    // 描画系定数
    private let NUM_OF_IMAGES = 1
    private let TEXT_MARGIN_X: CGFloat = 10.0
    private let TEXT_MARGIN_Y: CGFloat = 5.0
    private let SEPARATOR_WIDTH: CGFloat = 1.0
    
    var comments = [String]()
    var commentsContentViews = [CommentContentView]()
    
    init(frame: CGRect, comments: [String]) {
        super.init(frame: frame)
        
        self.comments = comments
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.yellowColor()
        
        self.addSubview(contentView)
        
        self.backgroundColor = UIColor.yellowColor()
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
        
        for (var i = 0; i < self.comments.count; i++)  {
            let content = CommentContentView(frame: CGRectZero, comment: self.comments[i])
            self.commentsContentViews.append(content)
            self.contentView.addSubview(self.commentsContentViews[i])
            self.commentsContentViews[i].snp_makeConstraints { (make) in
                make.left.equalTo(self.contentView)
                make.width.equalTo(self.contentView)
                if i == 0 {
                    make.top.equalTo(self.contentView).offset(16)
                } else {
                    make.top.equalTo(self.commentsContentViews[i-1].snp_bottom).offset(16)
                }
                if i == self.comments.count-1 {
                    make.bottom.equalTo(self.contentView).offset(-16)
                }
            }
//            if (i != self.comments.count-1) {
//                // separator
//                let separator = UIView(frame: CGRectZero)
//                separator.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
//                self.contentView.addSubview(separator)
//                separator.snp_makeConstraints { (make) in
//                    make.top.equalTo(self.restaurantsCards[i].snp_bottom).offset(0)
//                    make.left.equalTo(self.contentView)
//                    make.width.equalTo(self.contentView)
//                    make.height.equalTo(self.SEPARATOR_WIDTH)
//                }
//            }
        }
    }

}
