//
//  TopResultCard.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps

class TopResultCard: ResultCardBase {
    
    // 描画系定数
    private let BASE_WIDTH: CGFloat = 343.0
    private let NUM_OF_IMAGES = 3
    private let CORNER_RADIUS: CGFloat = 5.0
    private let SEPARATOR_LINE_WIDTH : CGFloat = 1.0
    private let TEXT_MARGIN_X: CGFloat = 16.0
    private let TEXT_MARGIN_Y: CGFloat = 10.0
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var categoryView: CategoryLabelView!
    @IBOutlet weak var dayPriceIcon: UIImageView!
    @IBOutlet weak var dayPriceLabel: UILabel!

    @IBOutlet weak var nightPriceIcon: UIImageView!
    @IBOutlet weak var nightPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    
    var restaurant = Restaurant()
    var delegate: ResultCardBaseDelegate?
    
    class func instance() -> TopResultCard {
        return UINib(nibName: "TopResultCard", bundle: nil).instantiateWithOwner(self, options: nil)[0] as! TopResultCard
    }
        
    init(frame: CGRect, restaurant: Restaurant, delegate: ResultCardBaseDelegate) {
        super.init(frame: frame, restaurant: restaurant, imageNum: NUM_OF_IMAGES, color: Const.RANKING_TOP_COLOR, delegate: delegate)
        self.setupSubViews()
    }
    
    func setup(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubViews() {
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.contentView.layer.cornerRadius = CORNER_RADIUS
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.masksToBounds = false
        
        // 画像
        self.mainImageView.image = UIImage(named: "noimage")
        self.mainImageView.contentMode = .ScaleAspectFill
        self.mainImageView.clipsToBounds = true
        
        // レストラン名のラベル
        self.restaurantNameLabel.text = self.restaurant.shopName
        self.restaurantNameLabel.backgroundColor = UIColor.whiteColor()
        self.restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 24)
        self.restaurantNameLabel.numberOfLines = 2
        self.restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        self.restaurantNameLabel.textAlignment = .Center
        self.restaurantNameLabel.sizeToFit()
        
        // カテゴリ
        self.categoryView.setCategory(self.restaurant.category)
        self.categoryView.backgroundColor = Const.RANKING_TOP_COLOR
        
        self.dayPriceIcon.image = UIImage(named: "noimage")
        // 値段ラベル
        if (self.restaurant.dayPriceMin.isEmpty && self.restaurant.dayPriceMax.isEmpty) {
            self.dayPriceLabel.text = "-"
        } else {
        self.dayPriceLabel.text = "\(Utils.formatPriceString(self.restaurant.dayPriceMin))〜\(Utils.formatPriceString(self.restaurant.dayPriceMax))"
        }
        self.dayPriceLabel.numberOfLines = 2
        self.dayPriceLabel.sizeToFit()
        self.dayPriceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.dayPriceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 13)
        
        self.nightPriceIcon.image = UIImage(named: "noimage")
        if (self.restaurant.nightPriceMin.isEmpty && self.restaurant.nightPriceMax.isEmpty) {
            self.dayPriceLabel.text = "-"
        } else {
            self.nightPriceLabel.text = "\(Utils.formatPriceString(self.restaurant.nightPriceMin))〜\(Utils.formatPriceString(self.restaurant.nightPriceMax))"
        }
        self.nightPriceLabel.numberOfLines = 2
        self.nightPriceLabel.sizeToFit()
        self.nightPriceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.nightPriceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 13)
        
        // 距離ラベル
        self.distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), Utils.meterToMinutes(self.restaurant.distance))
        self.distanceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 13)
        self.distanceLabel.numberOfLines = 0
        self.distanceLabel.sizeToFit()
        self.distanceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        
        // 地図
        let lat = Double(self.restaurant.latitude) ?? 0.0
        let lon = Double(self.restaurant.longitude) ?? 0.0

        let camera = GMSCameraPosition.cameraWithLatitude(lat,longitude: lon, zoom: 15)
        self.mapView.camera = camera
        self.mapView.myLocationEnabled = true

        mapView.userInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.map = mapView
        
        // 画像のダウンロード
        self.acquireImages()
        
        self.layoutIfNeeded()
    }
    
    // TODO: - Refactoring
    private func acquireImages() {
        if self.restaurant.imageUrls.count >= 1 {
            self.mainImageView.sd_setImageWithURL(NSURL(string: self.restaurant.imageUrls[0]), completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.mainImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.mainImageView.alpha = 1
                    }, completion: nil)
                })
        }
    }
    
    func resultTapped(sender: AnyObject) {
        self.delegate?.detailButtonTapped(self.restaurant)
    }
}
