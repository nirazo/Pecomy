//
//  CategorySelectionCell.swift
//  Pecomy
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class OnetimeFilterCell: UICollectionViewCell {
    
    fileprivate let defaultFontSize: CGFloat = 15.0    // ラベルのフォントサイズ
    fileprivate let label = UILabel()
    var labelString = "" {
        didSet {
            self.label.text = labelString
        }
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                super.isSelected = true
                self.backgroundColor = Const.PECOMY_THEME_COLOR
                self.label.textColor = UIColor.white
                self.layer.borderColor = Const.PECOMY_THEME_COLOR.cgColor
            } else if newValue == false {
                super.isSelected = false
                self.backgroundColor = UIColor.white
                self.label.textColor = Const.BASIC_GRAY_COLOR
                self.layer.borderColor = Const.RIGHT_GRAY_COLOR.cgColor
            }
        }
    }
    
    init(frame: CGRect, cellString: String = "", color: UIColor = Const.PECOMY_THEME_COLOR) {
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
        self.label.textAlignment = .center
        self.label.textColor = Const.BASIC_GRAY_COLOR
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
        self.label.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: defaultFontSize)
        
        // 角丸
        self.layer.cornerRadius = Const.CORNER_RADIUS
        self.layer.borderWidth = 1.0
        self.layer.borderColor = Const.RIGHT_GRAY_COLOR.cgColor
    }
}
