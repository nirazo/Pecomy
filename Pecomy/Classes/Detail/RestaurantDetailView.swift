//
//  RestaurantDetailView.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/11.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import SDWebImage
import GoogleMaps

protocol RestaurantDetailViewDelegate {
    func mapViewTapped()
}

enum RestaurantDetailCollectionViewTag: Int {
    case picturesView
    case richTagView
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
    
    @IBOutlet weak var middleSeparator: UIView!
    @IBOutlet weak var commentsView: CommentsView!
    @IBOutlet weak var picturesViewTitleLabel: UILabel!
    @IBOutlet weak var picturesView: UICollectionView!
    @IBOutlet weak var picturesBaseView: UIView!
    
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var richTagsViewTitleLabel: UILabel!
    @IBOutlet weak var richTagsView: UICollectionView!
    @IBOutlet weak var richTagViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var checkinBottomBar: CheckinBottomBar!
    
    
    var mapTapView = UIView(frame: .zero)
    var mapTappedAction : ((Restaurant) -> ())?

    class func instance() -> RestaurantDetailView {
        return R.nib.restaurantDetailView.instantiate(withOwner: self, options: nil)[0] as! RestaurantDetailView
    }
    
    init(frame: CGRect, restaurant: Restaurant) {
        super.init(frame: frame)
        self.setup(restaurant)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup(_ restaurant: Restaurant) {
        self.restaurant = restaurant
    }
    
    func setupView() {
        
        // 画像
        self.restaurantImageView.image = R.image.noimage()
        self.restaurantImageView.contentMode = .scaleAspectFill
        self.restaurantImageView.clipsToBounds = true
        
        // レストラン名のラベル
        self.restaurantNameLabel.text = self.restaurant.shopName
        self.restaurantNameLabel.backgroundColor = UIColor.white
        self.restaurantNameLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 16)
        self.restaurantNameLabel.numberOfLines = 2
        self.restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        self.restaurantNameLabel.sizeToFit()
        
        // カテゴリ
        self.categoryLabelView.setCategory(self.restaurant.category)
        if (!self.restaurant.category.isEmpty) {
            self.categoryLabelView.backgroundColor = Const.RANKING_TOP_COLOR
        }
        
        self.dayPriceIcon.image = R.image.time_day()
        // 値段ラベル
        if (self.restaurant.dayPriceRangeWithoutLabel.isEmpty) {
            self.dayPriceLabel.text = "-"
        } else {
            self.dayPriceLabel.text = "\(self.restaurant.dayPriceRangeWithoutLabel)"
        }
        self.dayPriceLabel.numberOfLines = 1
        self.dayPriceLabel.sizeToFit()
        self.dayPriceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.dayPriceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        
        self.nightPriceIcon.image = R.image.time_night()
        if (self.restaurant.nightPriceRangeWithoutLabel.isEmpty) {
            self.nightPriceLabel.text = "-"
        } else {
            self.nightPriceLabel.text = "\(self.restaurant.nightPriceRangeWithoutLabel)"
        }
        self.nightPriceLabel.numberOfLines = 1
        self.nightPriceLabel.sizeToFit()
        self.nightPriceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.nightPriceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        
        // 距離ラベル
        self.distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), Utils.meterToMinutes(restaurant.distance))
        self.distanceLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        self.distanceLabel.numberOfLines = 0
        self.distanceLabel.sizeToFit()
        self.distanceLabel.textColor = UIColor(red: 108/255.0, green: 108/255.0, blue: 108/255.0, alpha: 1.0)
        
        // 地図
        let lat = self.restaurant.latitude
        let lon = self.restaurant.longitude
        let camera = GMSCameraPosition.camera(withLatitude: lat,longitude: lon, zoom: 15)
        self.mapView.camera = camera
        self.mapView.isMyLocationEnabled = true
        
        self.mapView.isUserInteractionEnabled = false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.map = mapView
        
        // 地図のグラデーション
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)   //開始ポイント
        gradientLayer.endPoint = CGPoint(x: 0.4, y: 0.5)    //終了ポイント
        self.mapView.layer.mask = self.gradientLayer
        
        self.mapTapView.backgroundColor = UIColor.clear
        self.addSubview(self.mapTapView)
        self.mapTapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.mapView)
            make.left.equalTo(self.mapView)
            make.size.equalTo(self.mapView)
        }
        let tr = UITapGestureRecognizer(target: self, action: #selector(RestaurantDetailView.mapViewTapped(_ :)))
        self.mapTapView.addGestureRecognizer(tr)
        
        
        // セパレータ
        self.middleSeparator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        
        // 営業時間
        self.businessHourTitleLabel.text = NSLocalizedString("BusinessHourTitle", comment: "")
        self.businessHourTitleLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.businessHourTitleLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        
        self.dayBusinessHourLabel.text = self.replaceBusinessHour(self.restaurant.businessHours)
        self.dayBusinessHourLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.dayBusinessHourLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        
        // レビューリスト
        self.commentsView.setup(withComments: restaurant.reviewSubjects)
        
        // その他写真ラベル
        self.picturesViewTitleLabel.text = NSLocalizedString("PicturesViewTitle", comment: "")
        self.picturesViewTitleLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.picturesViewTitleLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 14)
        
        // separator
        self.middleSeparator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        self.bottomSeparator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        
        // その他の写真
        self.picturesView.backgroundColor = UIColor.clear
        
        // リッチタグラベル
        self.richTagsViewTitleLabel.text = NSLocalizedString("RichTagsTitle", comment: "")
        self.richTagsViewTitleLabel.textColor = Const.RANKING_SECOND_RIGHT_COLOR
        self.richTagsViewTitleLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 14)
        
        self.richTagsView.backgroundColor = UIColor.clear
        
        // 画像のダウンロード
        self.acquireImages()
        
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.mapView.layer.bounds
        self.picturesView.collectionViewLayout = PictureCollectionViewFlowLayout()
        self.picturesView.register(PictureCollectionViewCell.self, forCellWithReuseIdentifier: "PicCell")
        self.richTagsView.register(RichTagCollectionViewCell.self, forCellWithReuseIdentifier: "TagCell")
        
        self.richTagViewHeightConstraint.constant = self.richTagsView.contentSize.height
    }
    
    fileprivate func acquireImages() {
        if self.restaurant.imageUrls.count == 0 {
            return
        }
        guard let url = URL(string: self.restaurant.imageUrls[0]) else { return }
        self.restaurantImageView.sd_setImage(with: url) { [weak self](image, error, cacheType, imageURL) in
            guard let strongSelf = self else { return }
            strongSelf.restaurantImageView.alpha = 0
            strongSelf.commentsView.image = image
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseInOut, animations: {() -> Void in
                strongSelf.restaurantImageView.alpha = 1
                }, completion: nil)
            }
    }
    
    func mapViewTapped(_ sender: AnyObject) {
        self.mapTappedAction?(self.restaurant)
    }
    
    func replaceBusinessHour(_ hour: String) -> String {
        let pattern = "(?<=.)[\\[]"
        return hour.replacingOccurrences(of: pattern, with: "\n[", options: .regularExpression)
    }
    
}
