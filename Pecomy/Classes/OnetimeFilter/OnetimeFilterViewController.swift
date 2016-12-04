//
//  CategorySelectionViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/10/21.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

enum DeviceType {
    case iPhone4, iPhone5, iPhone6, iPhone6Plus, other
    
    init(size: CGSize) {
        switch size {
        case CGSize(width: 320.0, height: 480.0): self = .iPhone4
        case CGSize(width: 320.0, height: 568.0): self = .iPhone5
        case CGSize(width: 375.0, height: 667.0): self = .iPhone6
        case CGSize(width: 414.0, height: 736.0): self = .iPhone6Plus
        default: self = .other
        }
    }
}

protocol OnetimeFilterViewControllerDelegate {
    func closeButtonTapped()
    func startSearch(_ budget: Budget, numOfPeople: NumOfPeople, genre: Genre)
}

class OnetimeFilterViewController: UIViewController {
    fileprivate let kCellReuse: String = "Cell"
    fileprivate let kHeaderReuse: String = "HeaderView"
    fileprivate let contentView = UIView()
    fileprivate var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let collectionViewConfig: OnetimeFilterCollectionViewConfig
    fileprivate let bottomButtonsBgView = UIView(frame: .zero)
    fileprivate let cancelButton = UIButton(frame: .zero)
    fileprivate let startButton = UIButton(frame: .zero)
    
    fileprivate let deviceType = DeviceType(size: UIScreen.main.bounds.size)
    
    var delegate: OnetimeFilterViewControllerDelegate?
    
    var currentBudget: Budget
    var currentNumOfPeople: NumOfPeople
    var currentGenre: Genre
    
    var enableCancel: Bool
    
    init(budget: Budget = .unspecified, numOfPeople: NumOfPeople = .one, genre: Genre = .all, enableCancel: Bool = true) {
        self.collectionViewConfig = OnetimeFilterCollectionViewConfig(budget: budget, numOfPeople: numOfPeople, genre: genre)
        self.enableCancel = enableCancel
        self.currentBudget = budget
        self.currentNumOfPeople = numOfPeople
        self.currentGenre = genre
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.layer.cornerRadius = Const.CORNER_RADIUS
        self.contentView.clipsToBounds = true
        
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        self.contentView.backgroundColor = UIColor.white
        self.view.addSubview(self.contentView)
        self.contentView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(44)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-44)
        }
        
        // タイトル
        let titleLabel = UILabel(frame: .zero)
        titleLabel.text = NSLocalizedString("OnetimeFilterTitle", comment: "")
        titleLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 22)
        titleLabel.textColor = Const.PECOMY_THEME_COLOR
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(25)
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(34.5)
            make.width.equalTo(self.contentView)
        }
        
        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

        self.collectionView.center = self.view.center
        
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self.collectionViewConfig
        self.collectionView.backgroundColor = .white
        self.collectionView.register(OnetimeFilterCell.self, forCellWithReuseIdentifier: kCellReuse)
        self.collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderReuse)
        self.collectionView.allowsMultipleSelection = true
        
        self.view.addSubview(self.collectionView)
        
        var titleBottomMargin: CGFloat = 0
        switch self.deviceType {
        case .iPhone4:
            titleBottomMargin = 10
        case .iPhone5:
            titleBottomMargin = 15
        case .iPhone6, .iPhone6Plus:
            titleBottomMargin = 50.0
        default:
            titleBottomMargin = 50.0
        }
        self.collectionView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
            make.top.equalTo(titleLabel.snp_bottom).offset(titleBottomMargin)
            make.bottom.equalTo(self.contentView.snp_bottom).offset(-64)
        }
        
        self.bottomButtonsBgView.backgroundColor = UIColor(red: 235.0/255.0, green: 231.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        self.contentView.addSubview(self.bottomButtonsBgView)
        self.bottomButtonsBgView.snp_makeConstraints { (make) in
            make.top.equalTo(self.collectionView.snp_bottom)
            make.left.equalTo(self.contentView)
            make.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        // スタートボタン
        self.startButton.layer.cornerRadius = Const.CORNER_RADIUS
        self.startButton.backgroundColor = Const.PECOMY_THEME_COLOR
        self.startButton.titleLabel?.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 18)
        self.startButton.setTitle(NSLocalizedString("StartTitle", comment: ""), for: UIControlState())
        self.bottomButtonsBgView.addSubview(self.startButton)
        self.startButton.addTarget(self, action: #selector(OnetimeFilterViewController.startButtonTapped(_:)), for: .touchUpInside)
        
        if (self.enableCancel) {
            // キャンセルボタン
            self.cancelButton.layer.cornerRadius = Const.CORNER_RADIUS
            self.cancelButton.backgroundColor = UIColor(red: 129.0/255.0, green: 152.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            self.cancelButton.titleLabel?.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 18)
            self.cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), for: UIControlState())
            self.cancelButton.addTarget(self, action: #selector(OnetimeFilterViewController.cancelButtonTapped(_:)), for: .touchUpInside)
            
            self.bottomButtonsBgView.addSubview(self.cancelButton)
            self.cancelButton.snp_makeConstraints { (make) in
                make.top.equalTo(self.bottomButtonsBgView).offset(10)
                make.left.equalTo(self.bottomButtonsBgView).offset(10)
                make.width.equalTo(self.bottomButtonsBgView.snp_width).dividedBy(2.61)
                make.height.equalTo(44)
            }
            self.startButton.snp_makeConstraints { (make) in
                make.top.equalTo(self.bottomButtonsBgView).offset(10)
                make.left.equalTo(self.cancelButton.snp_right).offset(10)
                make.right.equalTo(self.bottomButtonsBgView).offset(-10)
                make.height.equalTo(44)
            }
        } else {
            self.startButton.snp_makeConstraints { (make) in
                make.top.equalTo(self.bottomButtonsBgView).offset(10)
                make.left.equalTo(self.contentView).offset(10)
                make.right.equalTo(self.contentView).offset(-10)
                make.height.equalTo(44)
            }
        }
    }
    
    //MARK: - button callbacks
    func cancelButtonTapped(_ sender: AnyObject) {
        if (self.enableCancel) {
            self.delegate?.closeButtonTapped()
        }
    }
    
    func startButtonTapped(_ sender: AnyObject) {
        self.delegate?.startSearch(self.currentBudget, numOfPeople: self.currentNumOfPeople, genre: self.currentGenre)
    }
}

extension OnetimeFilterViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItems = collectionView.indexPathsForSelectedItems
        guard let selecteds = selectedItems else { return }
        for index in selecteds {
            if ((index.section == indexPath.section) && (index.row != indexPath.row)) {
                collectionView.deselectItem(at: index, animated: false)
            }
        }
        switch indexPath.section {
            case OnetimeSections.budget.hashValue:
            self.currentBudget = Budget(rawValue: indexPath.row)!
            case OnetimeSections.people.hashValue:
            self.currentNumOfPeople = NumOfPeople(rawValue: indexPath.row)!
            case OnetimeSections.genre.hashValue:
            self.currentGenre = Genre(rawValue: indexPath.row)!
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionViewScrollPosition())
    }

    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let viewSize = collectionView.frame.size
        var cellHeight: CGFloat = 0.0
        switch self.deviceType {
        case .iPhone4:
            cellHeight = 30
        case .iPhone5:
            cellHeight = 40
        case .iPhone6, .iPhone6Plus:
            cellHeight = 48
        default:
            cellHeight = 48
        }
        
        if(indexPath.section == OnetimeSections.genre.hashValue && indexPath.row == Genre.all.hashValue) {
            return CGSize(width: viewSize.width, height: cellHeight)
        } else {
            return CGSize(width: (viewSize.width-20)/3, height: cellHeight) // The size of one cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 150, height: 18)  // Header size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        var bottomMargin: CGFloat = 0.0
        switch self.deviceType {
        case .iPhone4:
            bottomMargin = 10
        case .iPhone5:
            bottomMargin = 20
        case .iPhone6, .iPhone6Plus:
            bottomMargin = 30
        default:
            bottomMargin = 30
        }
        return UIEdgeInsetsMake(5, 0, bottomMargin, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 9.9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
}
