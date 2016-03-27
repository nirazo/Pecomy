//
//  OnetimeFilterCollectionViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit

enum OnetimeSections {
    case Budget, People, Genre, _counter
}

class OnetimeFilterCollectionViewConfig: NSObject {
    let kCellReuse : String = "Cell"
    var currentBudget: Budget
    var currentNumOfPeople: NumOfPeople
    var currentGenre: Genre
    
    init(budget: Budget = .Unspecified, numOfPeople: NumOfPeople = .One, genre: Genre = .All) {
        self.currentBudget = budget
        self.currentNumOfPeople = numOfPeople
        self.currentGenre = genre
        super.init()
    }

}

extension OnetimeFilterCollectionViewConfig: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : OnetimeFilterCell = collectionView.dequeueReusableCellWithReuseIdentifier(self.kCellReuse, forIndexPath: indexPath) as! OnetimeFilterCell
        switch indexPath.section {
        case OnetimeSections.Budget.hashValue:
            guard let budget = Budget(rawValue: indexPath.row) else { return cell }
            cell.labelString = budget.valueForDisplay()
            if (indexPath.row == self.currentBudget.rawValue) {
                cell.selected = true
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        case OnetimeSections.People.hashValue:
            guard let people = NumOfPeople(rawValue: indexPath.row) else { return cell }
            cell.labelString = people.valueForDisplay()
            if (indexPath.row == self.currentNumOfPeople.rawValue) {
                cell.selected = true
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
        case OnetimeSections.Genre.hashValue:
            guard let genre = Genre(rawValue: indexPath.row) else { return cell }
            cell.labelString = genre.valueForDisplay()
            if (indexPath.row == self.currentGenre.rawValue) {
                cell.selected = true
                collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
            }
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
}

