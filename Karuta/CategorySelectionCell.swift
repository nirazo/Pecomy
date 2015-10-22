//
//  CategorySelectionCell.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

class CategorySelectionCell: UICollectionViewCell {
    
    let cell: CategoryLabelView
    var category: CategoryIdentifier?
    
    override init(frame: CGRect) {
        self.cell = CategoryLabelView(frame: frame)
        super.init(frame: frame)
        self.cell.bounds = self.contentView.bounds
        self.cell.center = self.contentView.center
        self.contentView.addSubview(self.cell)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCategory(category: CategoryIdentifier) {
        self.category = category
        self.cell.setCategory(category.valueForDisplay())
    }
}
