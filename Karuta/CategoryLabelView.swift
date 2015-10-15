//
//  CategoryView.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/14.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class CategoryLabelView: UIView {
    
    let CORNER_RADIUS: CGFloat = 5.0
    let MARGIN_CATEGORY_VERTICAL: CGFloat = 3.0     // カテゴリラベル内の上下マージン
    let MARGIN_CATEGORY_HORIZONTAL: CGFloat = 2.0   // カテゴリラベル内の左右マージン
    let DEFAULT_FONT_SIZE_CATEGORY: CGFloat = 13    // カテゴリラベルのフォントサイズ
    let MAX_CATEGORY_NUM = 2                        // 表示するカテゴリの最大数
    
    var categoriesArray: [String]

    init(frame: CGRect, category: String) {
        // カテゴリのsplit
        let replacedCategory = category.stringByReplacingOccurrencesOfString("（.*）", withString: "", options: .RegularExpressionSearch, range: nil)
        categoriesArray = replacedCategory.componentsSeparatedByString("・")
        if (categoriesArray.count > MAX_CATEGORY_NUM) {
            categoriesArray = [String](categoriesArray[0..<MAX_CATEGORY_NUM])
        }
        super.init(frame: frame)
        self.setupSubViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews() {
        self.backgroundColor = Const.KARUTA_THEME_COLOR
        // 角丸
        self.layer.cornerRadius = CORNER_RADIUS
        
        for (var i=0; i < categoriesArray.count; i++) {
            let categoryLabel = UILabel()
            categoryLabel.text = categoriesArray[i]
            categoryLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: DEFAULT_FONT_SIZE_CATEGORY)
            categoryLabel.numberOfLines = 1
            categoryLabel.textAlignment = .Center
            categoryLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
            categoryLabel.adjustsFontSizeToFitWidth = true
            self.addSubview(categoryLabel)
            
            categoryLabel.snp_makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self.snp_bottom).multipliedBy(CGFloat(i*2+1)/CGFloat(categoriesArray.count*2))
                make.left.equalTo(self).offset(MARGIN_CATEGORY_HORIZONTAL)
                make.right.equalTo(self).inset(MARGIN_CATEGORY_HORIZONTAL)
                make.height.equalTo(self).dividedBy(CGFloat(categoriesArray.count))
            }
        }
    }
}
