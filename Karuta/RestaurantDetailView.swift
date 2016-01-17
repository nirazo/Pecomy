//
//  RestaurantDetailView.swift
//  Karuta
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps

enum RestaurantDetailCollectionViewTag: Int {
    case PicturesView
    case RichTagView
}

class RestaurantDetailView: UIView {
    let gradientLayer = CAGradientLayer()
    var restaurant = Restaurant()
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var restaurantImageView: UIImageView!

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var categoryLabelView: CategoryLabelView!
    @IBOutlet weak var dayPriceIcon: UIImageView!
    @IBOutlet weak var nightPriceIcon: UIImageView!
    @IBOutlet weak var dayPriceLabel: UILabel!
    @IBOutlet weak var nightPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var telButton: TelButton!
    @IBOutlet weak var businessHourTitleLabel: UILabel!
    @IBOutlet weak var dayBusinessHourLabel: UILabel!
    @IBOutlet weak var nightBusinessHourLabel: UILabel!
    
    @IBOutlet weak var middleSeparator: UIView!
    @IBOutlet weak var commentsView: CommentsView!
    @IBOutlet weak var picturesViewTitleLabel: UILabel!
    @IBOutlet weak var picturesView: UICollectionView!
    @IBOutlet weak var picturesBaseView: UIView!
    
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var richTagsViewTitleLabel: UILabel!
    @IBOutlet weak var richTagsView: UICollectionView!
    @IBOutlet weak var richTagViewHeightConstraint: NSLayoutConstraint!

    class func instance() -> RestaurantDetailView {
        return UINib(nibName: "RestaurantDetailView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! RestaurantDetailView
    }
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame)
        self.setup(restaurant)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    func setupView() {
        
        // 画像
        self.restaurantImageView.image = UIImage(named: "noimage")
        
        // レストラン名のラベル
        self.restaurantNameLabel.text = self.restaurant.shopName
        self.restaurantNameLabel.backgroundColor = UIColor.whiteColor()
        self.restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        self.restaurantNameLabel.numberOfLines = 2
        self.restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        self.restaurantNameLabel.sizeToFit()
        
        // カテゴリ
        self.categoryLabelView.setCategory(self.restaurant.category)
        self.categoryLabelView.backgroundColor = Const.RANKING_TOP_COLOR
        
        self.dayPriceIcon.image = UIImage(named: "noimage")
        // 値段ラベル
        self.dayPriceLabel.text = "\(self.restaurant.dayPriceMin)"
        self.dayPriceLabel.numberOfLines = 1
        self.dayPriceLabel.sizeToFit()
        self.dayPriceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.dayPriceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        
        self.nightPriceIcon.image = UIImage(named: "noimage")
        self.nightPriceLabel.text = "\(self.restaurant.nightPriceMin)"
        self.nightPriceLabel.numberOfLines = 1
        self.nightPriceLabel.sizeToFit()
        self.nightPriceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.nightPriceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        
        // 距離ラベル
        self.distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), restaurant.distance.meterToMinutes())
        self.distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        self.distanceLabel.numberOfLines = 0
        self.distanceLabel.sizeToFit()
        self.distanceLabel.textColor = UIColor(red: 108/255.0, green: 108/255.0, blue: 108/255.0, alpha: 1.0)
        
        // 地図
        let camera = GMSCameraPosition.cameraWithLatitude(35.681382,longitude: 139.766084, zoom: 15)
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true
        
        mapView.userInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(35.681382, 139.766084)
        marker.map = mapView
        
        // 地図のグラデーション
        gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradientLayer.startPoint = CGPointMake(0.0, 0.5)   //開始ポイント
        gradientLayer.endPoint = CGPointMake(0.4, 0.5)    //終了ポイント
        self.mapView.layer.mask = self.gradientLayer
        
        // セパレータ
        self.middleSeparator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        
        // 電話ボタン
        self.telButton.addTarget(self, action: "telButtonTapped:", forControlEvents: .TouchUpInside)
        
        // レビューリスト
        self.commentsView.setup(restaurant.reviewSubjects)
        
        // その他写真ラベル
        self.picturesViewTitleLabel.text = NSLocalizedString("PicturesViewTitle", comment: "")
        self.picturesViewTitleLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.picturesViewTitleLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        
        // separator
        self.middleSeparator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        self.bottomSeparator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        
        // その他の写真
        self.picturesView.backgroundColor = UIColor.clearColor()
        
        // リッチタグラベル
        self.richTagsViewTitleLabel.text = NSLocalizedString("RichTagsTitle", comment: "")
        self.richTagsViewTitleLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.richTagsViewTitleLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        
        self.richTagsView.backgroundColor = UIColor.clearColor()
        
        // 画像のダウンロード
        self.acquireImages()
        
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.mapView.layer.bounds
        self.picturesView.collectionViewLayout = PictureCollectionViewFlowLayout()
        self.picturesView.registerClass(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "PicCell")
        self.richTagsView.registerClass(RichTagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        
        self.richTagViewHeightConstraint.constant = self.richTagsView.contentSize.height
    }
    
    func telButtonTapped(sender: AnyObject) {
        print("tel!!!")
    }
    
    private func acquireImages() {
        if self.restaurant.imageUrls.count == 0 {
            return
        }
        let url = NSURL(string: self.restaurant.imageUrls[0])
        self.restaurantImageView.sd_setImageWithURL(url, completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.restaurantImageView.alpha = 0
            UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                weakSelf.restaurantImageView.alpha = 1
                }, completion: nil)
            })
    }
    
}
