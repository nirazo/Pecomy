//
//  RestaurantDetailViewRichTagCollectionViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit

class RestaurantDetailViewRichTagCollectionViewConfig: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let kCellReuse : String = "TagCell"
    
    var richTags = [RichTag]()
    
    init(richTags: [String]) {
        self.richTags = richTags.flatMap { RichTag(rawValue: $0) }
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuse, forIndexPath: indexPath) as?RichTagCollectionViewCell
        guard let c = cell else { fatalError("RichTagCollectionViewCell initialization error") }
        c.richTag = self.richTags[indexPath.row]
        return c
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.richTags.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize = UIScreen.mainScreen().bounds
        return CGSize(width: screenSize.width/2-26, height: 32) // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(0, 0)  // Header size
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 12.0
    }
}
