//
//  CardOverlayTextLabelView.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/21.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit

class CardOverlayTextLabelView: UIView {

    let CORNER_RADIUS: CGFloat = 10.0
    let DEFAULT_FONT_SIZE_CATEGORY: CGFloat = 24    // カテゴリラベルのフォントサイズ
    
    var text = ""
    var color = UIColor.whiteColor()
    
    init(frame: CGRect, text: String, color: UIColor = UIColor.whiteColor()) {
        
        super.init(frame: frame)
        self.text = text
        self.color = color
        
        self.commonInit()
        
        self.setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        // 角丸
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.borderColor = self.color.CGColor
        self.layer.borderWidth = 5.0
        self.layer.cornerRadius = CORNER_RADIUS
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        label.text = text.uppercaseString
        label.textAlignment = .Center
        label.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 24)
        label.textColor = self.color
        self.addSubview(label)
    }
    
    func setupSubViews() {

    }

}
