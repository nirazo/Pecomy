//
//  RestaurantDetailViewPictureCollectionViewConfig.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class RestaurantDetailViewPictureCollectionViewConfig: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let kCellReuse : String = "PicCell"
    
    var imageUrls = [String]()
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : PictureCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuse, forIndexPath: indexPath) as! PictureCollectionViewCell
        cell.urlString = self.imageUrls[indexPath.row]
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }
}
