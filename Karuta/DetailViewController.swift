//
//  DetailViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let ANALYTICS_TRACKING_CODE = AnaylyticsTrackingCode.RestaurantDetailViewController.rawValue
    
    var restaurant = Restaurant()
    var detailView: RestaurantDetailView?
    
    var picConfig: RestaurantDetailViewPictureCollectionViewConfig?
    var richTagConfig: RestaurantDetailViewRichTagCollectionViewConfig?
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.KARUTA_RESULT_BACK_COLOR
        self.edgesForExtendedLayout = .None
        
        self.picConfig = RestaurantDetailViewPictureCollectionViewConfig(imageUrls: self.restaurant.imageUrls)
        self.richTagConfig = RestaurantDetailViewRichTagCollectionViewConfig(richTags: self.restaurant.richTags)
        
        self.setupLayout()
    }
    
    func setupLayout() {
        self.detailView = RestaurantDetailView.instance()
        self.detailView?.setup(self.restaurant)
        self.detailView?.picturesView.delegate = self.picConfig
        self.detailView?.picturesView.dataSource = self.picConfig
        
        self.detailView?.picturesView.scrollEnabled = true
        self.detailView?.picturesView.userInteractionEnabled = true
        self.detailView?.richTagsView.delegate = self.richTagConfig
        self.detailView?.richTagsView.dataSource = self.richTagConfig
        self.view.addSubview(detailView!)
        self.detailView?.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        self.detailView?.setupView()
        self.detailView?.picturesView.reloadData()
        self.detailView?.picturesView.setNeedsLayout()
        
        self.detailView?.telButton.addTarget(self, action: "telTapped", forControlEvents: .TouchUpInside)
        
        self.detailView?.richTagsView.reloadData()
        self.detailView?.richTagsView.setNeedsLayout()
    }
    
    func telTapped() {
        print("tel tapped!!")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.ANALYTICS_TRACKING_CODE)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("tapped!: \(indexPath.row)")
    }

}
