//
//  OnetimeFilterCollectionViewConfig.swift
//  Karuta
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit

enum OnetimeSections {
    case Budget, People, Genre, _counter
}

class OnetimeFilterCollectionViewConfig: NSObject {
    let kCellReuse : String = "Cell"

}

extension OnetimeFilterCollectionViewConfig: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : OnetimeFilterCell = collectionView.dequeueReusableCellWithReuseIdentifier(self.kCellReuse, forIndexPath: indexPath) as! OnetimeFilterCell
        switch indexPath.section {
        case OnetimeSections.Budget.hashValue:
            guard let budget = Budget(rawValue: indexPath.row) else { return cell }
            cell.labelString = budget.valueForDisplay()
        case OnetimeSections.People.hashValue:
            guard let people = NumOfPeople(rawValue: indexPath.row) else { return cell }
            cell.labelString = people.valueForDisplay()
        case OnetimeSections.Genre.hashValue:
            guard let genre = Genre(rawValue: indexPath.row) else { return cell }
            cell.labelString = genre.valueForDisplay()
        default:
            return cell
        }
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return OnetimeSections._counter.hashValue
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case OnetimeSections.Budget.hashValue:
            return Budget._counter.hashValue
        case OnetimeSections.People.hashValue:
            return NumOfPeople._counter.hashValue
        case OnetimeSections.Genre.hashValue:
            return Genre._counter.hashValue
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedItems = collectionView.indexPathsForSelectedItems()
        guard let selecteds = selectedItems else { return }
        for index in selecteds {
            if ((index.section == indexPath.section) && (index.row != indexPath.row)) {
                collectionView.deselectItemAtIndexPath(index, animated: false)
            }
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let viewSize = collectionView.frame.size
        if(indexPath.section == OnetimeSections.Genre.hashValue && indexPath.row == Genre.All.hashValue) {
            return CGSize(width: viewSize.width, height: 50)
        } else {
            return CGSize(width: (viewSize.width-20)/3, height: 50) // The size of one cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(150, 18)  // Header size
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var headerView: UICollectionReusableView? = nil
        
        if (kind == UICollectionElementKindSectionHeader) {
            headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
            
            headerView!.backgroundColor = UIColor.whiteColor()
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 18))
            label.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 13)
            label.textColor = Const.RANKING_SECOND_RIGHT_COLOR
            
            switch indexPath.section {
            case OnetimeSections.Budget.hashValue:
                label.text = NSLocalizedString("BudgetTitle", comment: "")
            case OnetimeSections.People.hashValue:
                label.text = NSLocalizedString("NumOfPeopleTitle", comment: "")
            case OnetimeSections.Genre.hashValue:
                label.text = NSLocalizedString("GenreTitle", comment: "")
            default: break
            }
            headerView!.addSubview(label)
        }
        return headerView!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5, 0, 35.5, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
}

