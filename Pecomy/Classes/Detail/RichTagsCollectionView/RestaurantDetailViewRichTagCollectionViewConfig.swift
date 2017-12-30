//
//  RestaurantDetailViewRichTagCollectionViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class RestaurantDetailViewRichTagCollectionViewConfig: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    fileprivate let kCellReuse : String = "TagCell"
    
    var richTags = [RichTag]()
    
    init(richTags: [String]) {
        self.richTags = richTags.flatMap { RichTag(rawValue: $0) }
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellReuse, for: indexPath) as?RichTagCollectionViewCell
        guard let c = cell else { fatalError("RichTagCollectionViewCell initialization error") }
        c.richTag = self.richTags[indexPath.row]
        return c
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.richTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // do nothing
    }
}

extension RestaurantDetailViewRichTagCollectionViewConfig: UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        return CGSize(width: screenSize.width/2-26, height: 32) // The size of one cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)  // Header size
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(12, 0, 0, 0)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12.0
    }
}
