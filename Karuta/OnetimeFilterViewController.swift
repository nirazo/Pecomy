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
    func filterSelected(genre: Genre)
}

class OnetimeFilterViewController: UIViewController {
    private let kCellReuse: String = "Cell"
    private let kHeaderReuse: String = "HeaderView"
    private let contentView = UIView()
    private var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let collectionViewConfig: OnetimeFilterCollectionViewConfig
    private let bottomButtonsBgView = UIView(frame: CGRectZero)
    private let cancelButton = UIButton(frame: CGRectZero)
    private let startButton = UIButton(frame: CGRectZero)
    
    var delegate: CategorySelectionViewControllerDelegate?
    
    var currentBudget = Budget.LessThanThousand
    var currentNumOfPeople = NumOfPeople.One
    var currentGenre = Genre.All
    
    var enableCancel: Bool
    
    init(budget: Budget = .LessThanThousand, numOfPeople: NumOfPeople = .One, genre: Genre = .All, enableCancel: Bool = true) {
        self.collectionViewConfig = OnetimeFilterCollectionViewConfig(budget: budget, numOfPeople: numOfPeople, genre: genre)
        self.enableCancel = enableCancel
        super.init(nibName: nil, bundle: nil)
        self.currentBudget = budget
        self.currentNumOfPeople = numOfPeople
        self.currentGenre = genre
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.layer.cornerRadius = Const.CORNER_RADIUS
        self.contentView.clipsToBounds = true
        
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.contentView)
        self.contentView.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(44)
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-44)
        }
        
        // タイトル
        let titleLabel = UILabel(frame: CGRectZero)
        titleLabel.text = NSLocalizedString("OnetimeFilterTitle", comment: "")
        titleLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 22)
        titleLabel.textColor = Const.KARUTA_THEME_COLOR
        titleLabel.textAlignment = .Center
        self.view.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.contentView).offset(25)
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(34.5)
            make.width.equalTo(self.contentView)
        }
        
        // レイアウト作成
        let flowLayout = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)

        self.collectionView.center = self.view.center
        
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self.collectionViewConfig
        self.collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView.registerClass(OnetimeFilterCell.self, forCellWithReuseIdentifier: kCellReuse)
        self.collectionView.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: kHeaderReuse)
        self.collectionView.allowsMultipleSelection = true
        
        self.view.addSubview(self.collectionView)
        
        self.collectionView.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.right.equalTo(self.contentView).offset(-16)
            make.top.equalTo(titleLabel.snp_bottom).offset(50)
            make.height.equalTo(405.5)
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
        self.startButton.backgroundColor = Const.KARUTA_THEME_COLOR
        self.startButton.titleLabel?.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 18)
        self.startButton.setTitle(NSLocalizedString("StartTitle", comment: ""), forState: .Normal)
        self.bottomButtonsBgView.addSubview(self.startButton)
        self.startButton.addTarget(self, action: "startButtonTapped:", forControlEvents: .TouchUpInside)
        
        if (self.enableCancel) {
            // キャンセルボタン
            self.cancelButton.layer.cornerRadius = Const.CORNER_RADIUS
            self.cancelButton.backgroundColor = UIColor(red: 129.0/255.0, green: 152.0/255.0, blue: 178.0/255.0, alpha: 1.0)
            self.cancelButton.titleLabel?.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 18)
            self.cancelButton.setTitle(NSLocalizedString("Cancel", comment: ""), forState: .Normal)
            self.cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: .TouchUpInside)
            
            self.bottomButtonsBgView.addSubview(self.cancelButton)
            self.cancelButton.snp_makeConstraints { (make) in
                make.top.equalTo(self.bottomButtonsBgView).offset(10)
                make.left.equalTo(self.bottomButtonsBgView).offset(10)
                make.width.equalTo(136)
                make.height.equalTo(44)
            }
            self.startButton.snp_makeConstraints { (make) in
                make.top.equalTo(self.bottomButtonsBgView).offset(10)
                make.left.equalTo(self.cancelButton.snp_right).offset(10)
                make.width.equalTo(189)
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
    func cancelButtonTapped(sender: AnyObject) {
        if (self.enableCancel) {
            self.delegate?.closeButtonTapped()
        }
    }
    
    func startButtonTapped(sender: AnyObject) {
        print("start!!")
    }
}

extension OnetimeFilterViewController: UICollectionViewDelegate {
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
