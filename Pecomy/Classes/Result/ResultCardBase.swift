//
//  ResultCardBase.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit

protocol ResultCardBaseDelegate {
    func detailButtonTapped(restaurant: Restaurant)
}

class ResultCardBase: UIView {
    
    private let CORNER_RADIUS: CGFloat = 5.0

    init(frame: CGRect, restaurant: Restaurant, imageNum: Int, color: UIColor, delegate: ResultCardBaseDelegate) {
        super.init(frame: frame)
        
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.layer.masksToBounds = false
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.shadowOpacity = 0.7
        self.layer.shadowColor = UIColor.grayColor().CGColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.frame = self.frame
    }
}
