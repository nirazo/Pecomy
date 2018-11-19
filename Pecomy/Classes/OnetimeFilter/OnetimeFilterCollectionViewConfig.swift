//
//  OnetimeFilterCollectionViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/02.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

enum OnetimeSections {
    case budget, people, genre, _counter
}

class OnetimeFilterCollectionViewConfig: NSObject {
    let kCellReuse : String = "Cell"
    var currentBudget: Budget
    var currentNumOfPeople: NumOfPeople
    var currentGenre: Genre
    
    init(budget: Budget = .unspecified, numOfPeople: NumOfPeople = .one, genre: Genre = .all) {
        self.currentBudget = budget
        self.currentNumOfPeople = numOfPeople
        self.currentGenre = genre
        super.init()
    }

}

extension OnetimeFilterCollectionViewConfig: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : OnetimeFilterCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.kCellReuse, for: indexPath) as! OnetimeFilterCell
        switch indexPath.section {
        case OnetimeSections.budget.hashValue:
            guard let budget = Budget(rawValue: indexPath.row) else { return cell }
            cell.labelString = budget.valueForDisplay()
            if (indexPath.row == self.currentBudget.rawValue) {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
            }
        case OnetimeSections.people.hashValue:
            guard let people = NumOfPeople(rawValue: indexPath.row) else { return cell }
            cell.labelString = people.valueForDisplay()
            if (indexPath.row == self.currentNumOfPeople.rawValue) {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
            }
        case OnetimeSections.genre.hashValue:
            guard let genre = Genre(rawValue: indexPath.row) else { return cell }
            cell.labelString = genre.valueForDisplay()
            if (indexPath.row == self.currentGenre.rawValue) {
                cell.isSelected = true
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition())
            }
        default:
            return cell
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return OnetimeSections._counter.hashValue
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case OnetimeSections.budget.hashValue:
            return Budget._counter.hashValue
        case OnetimeSections.people.hashValue:
            return NumOfPeople._counter.hashValue
        case OnetimeSections.genre.hashValue:
            return Genre._counter.hashValue
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var headerView: UICollectionReusableView? = nil
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath)
            
            headerView!.backgroundColor = UIColor.white
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 18))
            label.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 13)
            label.textColor = Const.RANKING_SECOND_RIGHT_COLOR
            
            switch indexPath.section {
            case OnetimeSections.budget.hashValue:
                label.text = NSLocalizedString("BudgetTitle", comment: "")
            case OnetimeSections.people.hashValue:
                label.text = NSLocalizedString("NumOfPeopleTitle", comment: "")
            case OnetimeSections.genre.hashValue:
                label.text = NSLocalizedString("GenreTitle", comment: "")
            default: break
            }
            headerView!.addSubview(label)
        }
        return headerView!
    }
}

