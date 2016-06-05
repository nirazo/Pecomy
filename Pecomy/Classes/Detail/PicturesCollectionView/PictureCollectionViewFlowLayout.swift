//
//  PictureCollectionViewFlowLayout.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class PictureCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        self.scrollDirection = .Horizontal
    }
}
