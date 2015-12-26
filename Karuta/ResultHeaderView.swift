//
//  ResultHeaderView.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/19.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class ResultHeaderView: UIView {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var rankIcon = UIImageView()
    var headerLabel = UILabel()
    
    init(frame: CGRect, section: Int) {
        super.init(frame: frame)
        self.headerLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        switch section {
        case 0:
            self.rankIcon.image = UIImage(named: "rank_first")
            self.headerLabel.text = NSLocalizedString("ResultRankFirstHeader", comment: "")
            self.headerLabel.textColor = Const.RANKING_TOP_COLOR
        case 1:
            self.rankIcon.image = UIImage(named: "rank_other")
            self.headerLabel.text = NSLocalizedString("ResultRankSecondHeader", comment: "")
            self.headerLabel.textColor = Const.RANKING_SECOND_COLOR
        default:
            break
        }
        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.setupViews()
    }
    
    func setupViews() {
        self.addSubview(self.rankIcon)
        self.rankIcon.snp_makeConstraints { (make) in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.bottom.equalTo(self)
        }
        self.addSubview(self.headerLabel)
        self.headerLabel.snp_makeConstraints { (make) in
            make.left.equalTo(self.rankIcon.snp_right).offset(10)
            make.width.equalTo(self).offset(-42)
            make.height.equalTo(self.rankIcon.snp_height)
            make.centerY.equalTo(self.rankIcon)
        }
    }
}
