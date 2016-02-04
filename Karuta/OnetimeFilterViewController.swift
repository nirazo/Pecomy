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
    func genreSelected(genre: Genre)
}

class OnetimeFilterViewController: UIViewController, UIGestureRecognizerDelegate {
    private let kCellReuse: String = "Cell"
    private let kHeaderReuse: String = "HeaderView"
    private let contentView = UIView()
    private var collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    let collectionViewConfig = OnetimeFilterCollectionViewConfig()
    
    var delegate: CategorySelectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentView.layer.cornerRadius = Const.CORNER_RADIUS
        
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
        let tr = UITapGestureRecognizer(target: self, action: "backgroundTapped:")
        tr.delegate = self
        self.view.addGestureRecognizer(tr)
        
        self.collectionView.delegate = self.collectionViewConfig
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
    }
    
    //MARK: - button callbacks
    func backgroundTapped(sender:UITapGestureRecognizer) {
        self.delegate?.closeButtonTapped()
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
