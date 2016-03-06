//
//  TelButton.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class TelButton: UIButton {
    
    let CORNER_RADIUS: CGFloat = 5.0
    let MARGIN_CATEGORY_VERTICAL: CGFloat = 5.0     // カテゴリラベル内の上下マージン
    let MARGIN_CATEGORY_HORIZONTAL: CGFloat = 5.0   // カテゴリラベル内の左右マージン
    let FONT_TEL = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
    let telString = NSLocalizedString("TelephoneCall", comment: "")
    let telImage = UIImageView(image: R.image.telephone())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        // 角丸
        self.layer.cornerRadius = CORNER_RADIUS
        
        self.backgroundColor = UIColor(red: 61/255, green: 204/255, blue: 60/255, alpha: 1.0)
        self.addSubview(self.telImage)
        
        self.telImage.snp_makeConstraints { (make) in
            make.left.equalTo(self).offset(8)
            make.centerY.equalTo(self)
            make.size.width.equalTo(28)
            make.size.height.equalTo(28)
        }
        
        let label = UILabel(frame: CGRectZero)
        label.text = self.telString
        label.font = self.FONT_TEL
        label.textColor = UIColor.whiteColor()
        self.addSubview(label)
        label.snp_makeConstraints { (make) in
            make.left.equalTo(self.telImage.snp_right).offset(8)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
            make.right.equalTo(self).offset(-8)
            make.centerY.equalTo(self.telImage)
        }        
    }
}
