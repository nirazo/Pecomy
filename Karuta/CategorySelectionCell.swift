//
//  CategorySelectionCell.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class CategorySelectionCell: UICollectionViewCell {
    
    let categoryView: CategoryLabelView
    var category: CategoryIdentifier? {
        didSet {
            if let category = self.category {
                self.categoryView.setCategory(category.valueForDisplay())
            }
        }
    }
    
    override init(frame: CGRect) {
        self.categoryView = CategoryLabelView(frame: frame, category: "")
        super.init(frame: frame)
        self.contentView.addSubview(self.categoryView)
        
        self.self.categoryView.snp_makeConstraints { (make) in
            make.centerX.equalTo(self.contentView)
            make.centerY.equalTo(self.contentView)
            make.size.equalTo(self.contentView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
