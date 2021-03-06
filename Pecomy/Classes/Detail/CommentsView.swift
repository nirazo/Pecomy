//
//  CommentsView.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class CommentsView: UIView {
    
    let contentView = UIView()
    let imageView = UIImageView()
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    var image = R.image.noimage() {
        didSet {
            self.imageView.image = image
        }
    }
    
    // 描画系定数
    fileprivate let NUM_OF_IMAGES = 1
    fileprivate let TEXT_MARGIN_X: CGFloat = 10.0
    fileprivate let TEXT_MARGIN_Y: CGFloat = 5.0
    fileprivate let SEPARATOR_WIDTH: CGFloat = 1.0
    fileprivate let MAX_COMMENTS_NUM = 3
    
    var comments = [String]()
    var commentsContentViews = [CommentContentView]()
    
    init(frame: CGRect, comments: [String]) {
        super.init(frame: frame)
        
        self.comments = comments
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.lightGray
        self.addSubview(contentView)
        
        self.backgroundColor = UIColor.lightGray
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(withComments: [String]) {
        self.comments = withComments
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.lightGray
        
        self.addSubview(contentView)
        
        self.imageView.image = self.image
        imageView.addSubview(self.blurView)
        self.contentView.addSubview(self.imageView)
        
        self.backgroundColor = UIColor.lightGray
        self.setupSubViews()
    }
    
    func setupSubViews() {
        self.contentView.snp.makeConstraints { (make) in
            make.size.equalTo(self)
            make.top.equalTo(self)
            make.left.equalTo(self)
        }
        self.contentView.layer.frame = self.contentView.bounds
        self.contentView.backgroundColor = UIColor.lightGray
        
        self.imageView.snp.makeConstraints { (make) in
            make.size.equalTo(self.contentView)
            make.top.equalTo(self.contentView)
            make.left.equalTo(self.contentView)
        }
        
        self.blurView.snp.makeConstraints { (make) in
            make.size.equalTo(self.imageView)
            make.top.equalTo(self.imageView)
            make.left.equalTo(self.imageView)
        }
        
        let loopCount = self.comments.count < MAX_COMMENTS_NUM ? self.comments.count : MAX_COMMENTS_NUM
        
        for i in 0..<loopCount  {
            let content = CommentContentView(frame: CGRect.zero, comment: self.comments[i])
            self.commentsContentViews.append(content)
            self.contentView.addSubview(self.commentsContentViews[i])
            self.commentsContentViews[i].snp.makeConstraints { (make) in
                make.left.equalTo(self.contentView).offset(16)
                make.right.equalTo(self.contentView).offset(-16)
                if i == 0 {
                    make.top.equalTo(self.contentView).offset(16)
                } else {
                    make.top.equalTo(self.commentsContentViews[i-1].snp.bottom).offset(16)
                }
                if i == loopCount-1 {
                    make.bottom.equalTo(self.contentView).offset(-16)
                }
            }
        }
    }
}
