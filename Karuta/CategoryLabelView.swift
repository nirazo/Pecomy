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
        self.clipsToBounds = true
        
        for (var i=0; i < categoriesArray.count; i++) {
            let categoryLabel = UILabel()
            categoryLabel.bounds = CGRectMake(0.0, 0.0, self.frame.size.width-MARGIN_CATEGORY_HORIZONTAL, self.frame.size.height/CGFloat(categoriesArray.count))
            categoryLabel.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height*CGFloat(i*2+1)/CGFloat(categoriesArray.count*2))
            categoryLabel.text = categoriesArray[i]
            categoryLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: DEFAULT_FONT_SIZE_CATEGORY)
            categoryLabel.numberOfLines = 1
            categoryLabel.textAlignment = .Center
            categoryLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
            categoryLabel.adjustsFontSizeToFitWidth = true
            self.addSubview(categoryLabel)
        }
    }
}
