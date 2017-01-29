//
//  ResultMessageHeaderView.swift
//  Pecomy
//
//  Created by Kenzo on 10/29/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class ResultMessageHeaderView: UIView {

    init(message: String) {
        super.init(frame: .zero)
        self.setupLayout(message)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout(_ message: String) {
        self.backgroundColor = Const.RANKING_TOP_COLOR
        let messageLabel = UILabel()
        messageLabel.text = message
        messageLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 16)
        messageLabel.textAlignment = .center
        messageLabel.textColor = .white
        messageLabel.numberOfLines = 0
        self.addSubview(messageLabel)
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(16)
            make.left.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-16)
            make.bottom.equalTo(self).offset(-10)
        }
    }
}
