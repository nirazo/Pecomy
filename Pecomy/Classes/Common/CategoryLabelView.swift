//
//  CategoryView.swift
//  Pecomy
//
//  Created by Kenzo on 2015/10/14.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class CategoryLabelView: UIView {
    
    let CORNER_RADIUS: CGFloat = 5.0
    let MARGIN_CATEGORY_VERTICAL: CGFloat = 5.0     // カテゴリラベル内の上下マージン
    let MARGIN_CATEGORY_HORIZONTAL: CGFloat = 5.0   // カテゴリラベル内の左右マージン
    let DEFAULT_FONT_SIZE_CATEGORY: CGFloat = 11    // カテゴリラベルのフォントサイズ
    let MAX_CATEGORY_NUM = 1                        // 表示するカテゴリの最大数
    var categoryLabels = [UILabel]()
    var categoriesArray = [String]()
    
    var contentView = UIView()
    
    init(frame: CGRect, category: String, color: UIColor = Const.PECOMY_THEME_COLOR) {
        // カテゴリのsplit
        let replacedCategory = category.stringByReplacingOccurrencesOfString("（.*）", withString: "", options: .RegularExpressionSearch, range: nil)
        self.categoriesArray = replacedCategory.componentsSeparatedByString("・")
        if (self.categoriesArray.count > MAX_CATEGORY_NUM) {
            self.categoriesArray = [String](self.categoriesArray[0..<MAX_CATEGORY_NUM])
        }
        super.init(frame: frame)
        self.commonInit()
        
        self.backgroundColor = color
        
        self.setupSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    func commonInit() {
        self.addSubview(self.contentView)
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.contentView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(MARGIN_CATEGORY_HORIZONTAL)
            make.right.equalTo(self).offset(-MARGIN_CATEGORY_HORIZONTAL)
            make.top.equalTo(self).offset(MARGIN_CATEGORY_VERTICAL)
            make.bottom.equalTo(self).offset(-MARGIN_CATEGORY_VERTICAL)
        }
        // 角丸
        self.layer.cornerRadius = CORNER_RADIUS
        self.setupSubViews()
    }
    
    func setCategory(category: String) {
        // カテゴリのsplit
        let replacedCategory = category.stringByReplacingOccurrencesOfString("（.*）", withString: "", options: .RegularExpressionSearch, range: nil)
        self.categoriesArray = replacedCategory.componentsSeparatedByString("・")
        if (self.categoriesArray.count > MAX_CATEGORY_NUM) {
            self.categoriesArray = [String](self.categoriesArray[0..<MAX_CATEGORY_NUM])
        }
        self.setupSubViews()
    }
    
    func setupSubViews() {
        
        // subViewsを全て削除
        for subview in self.contentView.subviews {
            subview.removeFromSuperview()
        }
        self.categoryLabels.removeAll()
        
        for i in 0..<self.categoriesArray.count {
            let categoryLabel = UILabel()
            categoryLabel.text = self.categoriesArray[i]
            categoryLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: DEFAULT_FONT_SIZE_CATEGORY)
            categoryLabel.numberOfLines = 1
            categoryLabel.textAlignment = .Center
            categoryLabel.textColor = Const.PECOMY_THEME_TEXT_COLOR
            categoryLabel.adjustsFontSizeToFitWidth = true
            self.addSubview(categoryLabel)
            
            self.categoryLabels.append(categoryLabel)
            self.contentView.addSubview(self.categoryLabels[i])
            
            self.categoryLabels[i].snp_makeConstraints { (make) in
                make.centerX.equalTo(self.contentView)
                if i == 0 {
                    make.top.equalTo(self.contentView)
                } else {
                    make.top.equalTo(self.categoryLabels[i-1].snp_bottom).offset(MARGIN_CATEGORY_VERTICAL)
                }
                make.left.equalTo(self.contentView)
                make.right.equalTo(self.contentView)
                if i == self.categoriesArray.count - 1 {
                    make.bottom.equalTo(self.contentView)
                }
            }
        }
    }
}
