//
//  CategorySelectionCell.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class OnetimeFilterCell: UICollectionViewCell {
    
    private let defaultFontSize: CGFloat = 15.0    // ラベルのフォントサイズ
    private let label = UILabel()
    var labelString = "" {
        didSet {
            self.label.text = labelString
        }
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                self.backgroundColor = Const.KARUTA_THEME_COLOR
                self.label.textColor = UIColor.whiteColor()
            } else if newValue == false {
                super.selected = false
                self.backgroundColor = UIColor.whiteColor()
                self.label.textColor = Const.BASIC_GRAY_COLOR
            }
        }
    }
    
    init(frame: CGRect, cellString: String = "", color: UIColor = Const.KARUTA_THEME_COLOR) {
        super.init(frame: frame)
        self.label.text = cellString
        self.commonInit()
        self.contentView.backgroundColor = color
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    func commonInit() {
        self.label.textAlignment = .Center
        self.label.textColor = Const.BASIC_GRAY_COLOR
        self.contentView.addSubview(self.label)
        self.label.snp_makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        self.label.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: defaultFontSize)
        
        // 角丸
        self.layer.cornerRadius = Const.CORNER_RADIUS
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Const.RIGHT_GRAY_COLOR.CGColor
    }
    
//    func highLight() {
//        self.contentView.backgroundColor = Const.KARUTA_THEME_COLOR
//        self.label.textColor = Const.KARUTA_THEME_COLOR
//    }
//    
//    func unHighLight() {
//        self.contentView.backgroundColor = UIColor.whiteColor()
//        self.label.textColor = Const.BASIC_GRAY_COLOR
//    }
}
