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
        self.layer.borderColor = Const.RIGHT_GRAY_COLOR.cgColor
        self.layer.borderWidth = 0.7
        self.clipsToBounds = true
        self.backgroundColor = UIColor(patternImage: R.image.progress_background()!)
        
        self.addSubview(self.progressView)
        self.progressView.backgroundColor = Const.PECOMY_THEME_COLOR
        self.progressView.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(0)
        }
    }
    
    // 進捗率を渡してプログレスバーを進める（戻す）
    func progress(withRatio: Float, completion: (()->())? = nil) {
        UIView.animate(withDuration: 0.2, animations: { [weak self] () in
            guard let strongSelf = self else { return }
            if withRatio >= 1.0 {
                strongSelf.progressView.backgroundColor = Const.RANKING_TOP_COLOR
            } else {
                strongSelf.progressView.backgroundColor = Const.PECOMY_THEME_COLOR
            }
            strongSelf.progressView.snp.remakeConstraints { make in
                make.top.left.height.equalTo(strongSelf)
                make.width.equalTo(strongSelf.snp.width).multipliedBy(withRatio)
            }
            strongSelf.layoutIfNeeded()
        }) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.20) { () in
                completion?()
            }
        }
    }
    
    // プログレスバーをリセット
    func reset() {
        self.progressView.frame.size = CGSize(width: 0.0, height: self.frame.size.height)
        self.progressView.backgroundColor = Const.PECOMY_THEME_COLOR
    }

}
