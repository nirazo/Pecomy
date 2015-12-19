//
//  CategorySelectionCell.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class CategorySelectionCell: UICollectionViewCell {
    
    let label: CategoryLabelView
    var category: CategoryIdentifier? {
        didSet {
            if let category = self.category {
                self.label.setCategory(category.valueForDisplay())
            }
        }
    }
    
    override init(frame: CGRect) {
        self.label = CategoryLabelView(frame: frame, category: "")
        super.init(frame: frame)
        self.label.bounds = self.contentView.bounds
        self.label.center = self.contentView.center
        self.contentView.addSubview(self.label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
