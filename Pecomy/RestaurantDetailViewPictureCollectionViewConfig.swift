//
//  RestaurantDetailViewPictureCollectionViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit

protocol DetailPictureCollectionViewConfigDelegate {
    func pictureTapped(imageView imageView: UIImageView, index: Int, urlStrings: [String])
}

class RestaurantDetailViewPictureCollectionViewConfig: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let kCellReuse : String = "PicCell"
    
    var imageUrls = [String]()
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
    }
    
    var delegate: DetailPictureCollectionViewConfigDelegate?
    
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
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(0, 0)  // Header size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10) // margin between cells
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PictureCollectionViewCell
        guard let c = cell else { return }
        self.delegate?.pictureTapped(imageView: c.imageView, index: indexPath.row, urlStrings: self.imageUrls)
    }
}
