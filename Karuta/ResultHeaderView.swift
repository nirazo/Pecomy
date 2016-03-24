//
//  ResultHeaderView.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/19.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class ResultHeaderView: UIView {
    
    var rankIcon = UIImageView()
    var headerLabel = UILabel()
    
    init(frame: CGRect, section: Int) {
        super.init(frame: frame)
        self.headerLabel.textAlignment = .Center
        switch section {
        case 0:
            self.rankIcon.image = R.image.rank_first()
            self.headerLabel.text = NSLocalizedString("ResultRankFirstHeader", comment: "")
            self.headerLabel.font = UIFont(name: "TimesNewRomanPS-BoldMT", size: 25)
            self.headerLabel.textColor = Const.RANKING_TOP_COLOR
        case 1:
            self.rankIcon.image = R.image.rank_other()
            self.headerLabel.text = NSLocalizedString("ResultRankSecondHeader", comment: "")
            self.headerLabel.font = UIFont(name: "HiraginoSans-W6", size: 18)
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
            make.centerX.equalTo(self)
            make.height.equalTo(21)
            make.width.equalTo(24)
        }
        self.addSubview(self.headerLabel)
        self.headerLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.rankIcon.snp_bottom).offset(4)
            make.centerX.equalTo(self)
            make.width.equalTo(self)
            make.height.equalTo(30)
        }
    }
}
