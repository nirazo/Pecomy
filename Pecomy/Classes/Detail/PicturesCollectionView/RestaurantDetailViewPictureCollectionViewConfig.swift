//
//  RestaurantDetailViewPictureCollectionViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

protocol DetailPictureCollectionViewConfigDelegate {
    func pictureTapped(_ imageView: UIImageView, index: Int, urlStrings: [String])
}

class RestaurantDetailViewPictureCollectionViewConfig: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let kCellReuse : String = "PicCell"
    
    var imageUrls = [String]()
    
    init(imageUrls: [String]) {
        self.imageUrls = imageUrls
    }
    
    var delegate: DetailPictureCollectionViewConfigDelegate?
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : PictureCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as! PictureCollectionViewCell
        cell.urlString = self.imageUrls[indexPath.row]
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageUrls.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? PictureCollectionViewCell
        guard let c = cell else { fatalError("PictureCollectionViewCell initialization error") }
        self.delegate?.pictureTapped(c.imageView, index: indexPath.row, urlStrings: self.imageUrls)
    }
}

extension RestaurantDetailViewPictureCollectionViewConfig: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100) // The size of one cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)  // Header size
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10) // margin between cells
    }

}
