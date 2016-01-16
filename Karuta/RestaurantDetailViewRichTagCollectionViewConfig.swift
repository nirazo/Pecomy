//
//  RestaurantDetailViewRichTagCollectionViewConfig.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

class RestaurantDetailViewRichTagCollectionViewConfig: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let kCellReuse : String = "TagCell"
    
    var richTags = [String]()
    
    init(richTags: [String]) {
        self.richTags = richTags
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : RichTagCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuse, forIndexPath: indexPath) as! RichTagCollectionViewCell
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.richTags.count
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // nothing
    }
}
