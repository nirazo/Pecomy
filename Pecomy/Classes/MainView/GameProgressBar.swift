//
//  GameProgressBar.swift
//  Pecomy
//
//  Created by Kenzo on 2016/04/23.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class GameProgressBar: UIView {
    var progressView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        // バーの下地
        self.layer.cornerRadius = Const.CORNER_RADIUS
        self.layer.borderColor = Const.RIGHT_GRAY_COLOR.CGColor
        self.layer.borderWidth = 0.7
        self.clipsToBounds = true
        self.backgroundColor = UIColor(patternImage: R.image.progress_background()!)
        
        self.addSubview(self.progressView)
        self.progressView.backgroundColor = Const.PECOMY_THEME_COLOR
        self.progressView.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(0)
        }
    }
    
    // 進捗率を渡してプログレスバーを進める（戻す）
    func progressWithRatio(ratio: Float) {
        UIView.animateWithDuration(0.2, animations: { [weak self] () in
            guard let strongSelf = self else { return }
            let r = ratio > 0.95 ? 0.95 : ratio
            strongSelf.progressView.snp_remakeConstraints { make in
                make.top.equalTo(strongSelf)
                make.left.equalTo(strongSelf)
                make.height.equalTo(strongSelf)
                make.width.equalTo(strongSelf.snp_width).multipliedBy(r)
            }
            strongSelf.layoutIfNeeded()
            })
    }
    
    // プログレスバーをリセット
    func reset() {
        self.progressView.frame.size = CGSizeMake(0.0, self.frame.size.height)
    }

}
