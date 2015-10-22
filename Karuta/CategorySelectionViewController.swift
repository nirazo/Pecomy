//
//  CategorySelectionViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import UIKit

protocol CategorySelectionViewControllerDelegate {
    func closeButtonTapped()
    func categorySelected(category: CategoryIdentifier)
}

class CategorySelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    private let kCellReuse : String = "CategoryCell"
    private var collectionView:UICollectionView!
    
    var delegate: CategorySelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)

        self.collectionView.center = self.view.center
        
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        let tr = UITapGestureRecognizer(target: self, action: "backgroundTapped:")
        tr.delegate = self
        self.view.addGestureRecognizer(tr)
        
        self.collectionView.alpha = 1.0
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.registerClass(CategorySelectionCell.self, forCellWithReuseIdentifier: kCellReuse)
        
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).multipliedBy(0.9)
            make.height.equalTo(self.view).multipliedBy(0.6)
            make.center.equalTo(self.view)
        }
    }
    
    //MARK: - UICollectionViewDelegate, UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : CategorySelectionCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellReuse, forIndexPath: indexPath) as! CategorySelectionCell
        let category = CategoryIdentifier(rawValue:indexPath.row)
        
        if let _ = category {
            cell.setCategory(category!)
        }
        
        cell.backgroundColor = UIColor.yellowColor()
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryIdentifier._counter.rawValue
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: false)
        if let _ = delegate {
            self.delegate!.categorySelected(CategoryIdentifier(rawValue: indexPath.row)!)
        }
    }
    
    //MARK: - button callbacks
    func backgroundTapped(sender:UITapGestureRecognizer) {
        self.delegate?.closeButtonTapped()
    }
    
    
//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        var reusableView : UICollectionReusableView? = nil
//        
//        // Create header
//        if (kind == UICollectionElementKindSectionHeader) {
//            // Create Header
//            var headerView : PackCollectionSectionView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: kCellheaderReuse, forIndexPath: indexPath) as PackCollectionSectionView
//            
//            reusableView = headerView
//        }
//        return reusableView!
//    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width/3-10, height: 40) // The size of one cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(self.view.frame.width, 20)  // Header size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 5, 20, 5) // margin between cells
    }
    
    //MARK: - UIGestureRecognizer Delegate
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if (touch.view == gestureRecognizer.view) {
            return true
        } else {
            return false
        }
    }
    
}
