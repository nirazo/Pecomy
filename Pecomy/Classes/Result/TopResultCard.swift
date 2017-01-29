//
//  TopResultCard.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps

class TopResultCard: ResultCardBase {
    
    // 描画系定数
    fileprivate let BASE_WIDTH: CGFloat = 343.0
    fileprivate let NUM_OF_IMAGES = 3
    fileprivate let CORNER_RADIUS: CGFloat = 5.0
    fileprivate let SEPARATOR_LINE_WIDTH : CGFloat = 1.0
    fileprivate let TEXT_MARGIN_X: CGFloat = 16.0
    fileprivate let TEXT_MARGIN_Y: CGFloat = 10.0
    
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
        return R.nib.topResultCard().instantiate(withOwner: self, options: nil)[0] as! TopResultCard
    }
        
    init(frame: CGRect, restaurant: Restaurant, delegate: ResultCardBaseDelegate) {
        super.init(frame: frame, restaurant: restaurant, imageNum: NUM_OF_IMAGES, color: Const.RANKING_TOP_COLOR, delegate: delegate)
        self.setupSubViews()
    }
    
    func setup(_ restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubViews() {
        
        // パーツ群を置くビュー
        self.contentView.backgroundColor = .white
        
        self.contentView.layer.cornerRadius = CORNER_RADIUS
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        self.backgroundColor = .clear
        self.layer.cornerRadius = CORNER_RADIUS
        self.layer.masksToBounds = false
        
        // 画像
        self.mainImageView.image = R.image.noimage()
        self.mainImageView.contentMode = .scaleAspectFill
        self.mainImageView.clipsToBounds = true
        
        // レストラン名のラベル
        self.restaurantNameLabel.text = self.restaurant.shopName
        self.restaurantNameLabel.backgroundColor = .white
        self.restaurantNameLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 24)
        self.restaurantNameLabel.numberOfLines = 2
        self.restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        self.restaurantNameLabel.textAlignment = .center
        self.restaurantNameLabel.sizeToFit()
        
        // カテゴリ
        self.categoryView.setCategory(self.restaurant.category)
        self.categoryView.backgroundColor = Const.RANKING_TOP_COLOR
        
        self.dayPriceIcon.image = R.image.time_day()
        // 値段ラベル
        if (self.restaurant.dayPriceRangeWithoutLabel.isEmpty) {
            self.dayPriceLabel.text = "-"
        } else {
        self.dayPriceLabel.text = "\(self.restaurant.dayPriceRangeWithoutLabel)"
        }
        self.dayPriceLabel.numberOfLines = 2
        self.dayPriceLabel.sizeToFit()
        self.dayPriceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.dayPriceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 13)
        
        self.nightPriceIcon.image = R.image.time_night()
        if (self.restaurant.nightPriceRangeWithoutLabel.isEmpty) {
            self.nightPriceLabel.text = "-"
        } else {
            self.nightPriceLabel.text = "\(self.restaurant.nightPriceRangeWithoutLabel)"
        }
        self.nightPriceLabel.numberOfLines = 2
        self.nightPriceLabel.sizeToFit()
        self.nightPriceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.nightPriceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 13)
        
        // 距離ラベル
        self.distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), Utils.meterToMinutes(self.restaurant.distance))
        self.distanceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 13)
        self.distanceLabel.numberOfLines = 0
        self.distanceLabel.sizeToFit()
        self.distanceLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        
        // 地図
        let lat = Double(self.restaurant.latitude)
        let lon = Double(self.restaurant.longitude)

        let camera = GMSCameraPosition.camera(withLatitude: lat,longitude: lon, zoom: 15)
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true

        mapView.isUserInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.map = mapView
        
        // 画像のダウンロード
        self.acquireImages()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TopResultCard.resultTapped))
        self.addGestureRecognizer(tapGesture)
        
        self.layoutIfNeeded()
    }
    
    // TODO: - Refactoring
    fileprivate func acquireImages() {
        if self.restaurant.imageUrls.count >= 1 {
            self.mainImageView.sd_setImage(with: URL(string: self.restaurant.imageUrls[0])) {[weak self] (image, error, imageCacheType, imageURL) in
                self!.mainImageView.alpha = 0
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                    self!.mainImageView.alpha = 1
                    }, completion: nil)
                }
        }
    }
    
    func resultTapped() {
        self.delegate?.detailButtonTapped(self.restaurant)
    }
}
