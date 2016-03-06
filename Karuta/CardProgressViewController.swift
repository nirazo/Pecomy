//
//  CardProgressViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/11.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class CardProgressViewController: UIViewController {

    let progressBaseView: UIView
    let progressView: UIView
    let contentView: UIView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.progressBaseView = UIView()
        self.progressView = UIView()
        self.contentView = UIView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.cornerRadius = Const.CORNER_RADIUS
        
        // ドロップシャドウ
        self.view.layer.masksToBounds = false
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.layer.cornerRadius = 5.0
        self.view.layer.shadowOffset = CGSizeMake(0.0, 3.0)
        self.view.layer.shadowRadius = 3.0
        self.view.layer.shadowColor = UIColor.grayColor().CGColor
        self.view.layer.shadowOpacity = 0.9
        
        self.view.addSubview(self.contentView)
        self.contentView.snp_makeConstraints { make in
            make.left.equalTo(self.view)
            make.top.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        self.setupSubViews()
    }
    
    private func setupSubViews() {
        let label = UILabel(frame: CGRectZero)
        label.text = NSLocalizedString("SearchingRestaurant", comment: "")
        label.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 18)
        label.textColor = Const.KARUTA_THEME_COLOR
        label.textAlignment = .Center
        self.contentView.addSubview(label)
        label.snp_makeConstraints { make in
            make.left.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset(5)
            make.width.equalTo(self.contentView)
            make.height.equalTo(24)
        }
        
        // バーの下地
        self.progressBaseView.layer.cornerRadius = Const.CORNER_RADIUS
        self.progressBaseView.layer.borderColor = Const.RIGHT_GRAY_COLOR.CGColor
        self.progressBaseView.layer.borderWidth = 0.7
        self.progressBaseView.clipsToBounds = true
        self.contentView.addSubview(progressBaseView)
        progressBaseView.snp_makeConstraints { make in
            make.top.equalTo(label.snp_bottom).offset(2.5)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.height.equalTo(8)
        }
        
        progressBaseView.addSubview(self.progressView)
        self.progressView.backgroundColor = Const.KARUTA_THEME_COLOR
        self.progressView.snp_makeConstraints { make in
            make.top.equalTo(progressBaseView)
            make.left.equalTo(progressBaseView)
            make.height.equalTo(progressBaseView)
            make.width.equalTo(0)
        }
    }

    // 進捗率を渡してプログレスバーを進める（戻す）
    func progressWithRatio(ratio: Float) {
        UIView.animateWithDuration(0.2, animations: { [weak self] () in
            guard let strongSelf = self else { return }
            let r = ratio > 0.95 ? 0.95 : ratio
            strongSelf.progressView.snp_remakeConstraints { make in
                make.top.equalTo(strongSelf.progressBaseView)
                make.left.equalTo(strongSelf.progressBaseView)
                make.height.equalTo(strongSelf.progressBaseView)
                make.width.equalTo(strongSelf.progressBaseView.snp_width).multipliedBy(r)
            }
            strongSelf.view.layoutIfNeeded()
        })
    }
    
    // プログレスバーをリセット
    func reset() {
        self.progressView.frame.size = CGSizeMake(0.0, self.view.frame.size.height)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
