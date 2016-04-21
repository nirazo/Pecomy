//
//  DetailViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2016年 Pecomy. All rights reserved.
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
        self.view.backgroundColor = Const.PECOMY_RESULT_BACK_COLOR
        self.edgesForExtendedLayout = .None
        
        self.picConfig = RestaurantDetailViewPictureCollectionViewConfig(imageUrls: self.restaurant.imageUrls)
        self.richTagConfig = RestaurantDetailViewRichTagCollectionViewConfig(richTags: self.restaurant.richTags)
        
        self.setupLayout()
    }
    
    func setupLayout() {
        self.detailView = RestaurantDetailView.instance()
        
        // マップ表示
        self.detailView?.mapTappedAction = { [weak self] (restaurant) in
            guard let strongSelf = self else {
                return
            }
            let mapVC = MapViewController(restaurant: restaurant)
            mapVC.navigationItem.title = restaurant.shopName
            let backButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .Plain, target: nil, action: nil)
            strongSelf.navigationItem.backBarButtonItem = backButtonItem
            strongSelf.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        self.picConfig?.delegate = self
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
        
        self.detailView?.telButton.addTarget(self, action: #selector(DetailViewController.telButtonTapped(_:)), forControlEvents: .TouchUpInside)
        
        self.detailView?.richTagsView.reloadData()
        self.detailView?.richTagsView.setNeedsLayout()
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
    
    func telButtonTapped(sender: AnyObject) {
        let telURL = NSURL(string: "tel://\(self.restaurant.tel)")
        if let telURL = telURL {
            let ac = UIAlertController(title: "", message: NSLocalizedString("TelAlertMessage", comment: ""), preferredStyle: .Alert)
            let okAction = UIAlertAction(title: NSLocalizedString("TelAlertTelButton", comment: ""),
                style: .Default, handler: { (action) in
                    UIApplication.sharedApplication().openURL(telURL)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                style: .Default, handler: nil)
            ac.addAction(cancelAction)
            ac.addAction(okAction)
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }
}

extension DetailViewController: DetailPictureCollectionViewConfigDelegate {
    func pictureTapped(imageView imageView: UIImageView, index: Int, urlStrings: [String]) {
        let photoVC = PhotoViewerViewController(imageUrlStrings: urlStrings, index: index)
        photoVC.modalPresentationStyle = .OverCurrentContext
        self.presentViewController(photoVC, animated: false, completion: nil)
        UIApplication.sharedApplication().keyWindow?.addSubview(photoVC.view)
        photoVC.display(view: self.view, imageView: imageView)
    }
}
