//
//  PictureCollectionViewFlowLayout.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class PictureCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        self.scrollDirection = .Horizontal
    }
}
