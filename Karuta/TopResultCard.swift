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
    
    let gradientLayer = CAGradientLayer()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var categoryView: CategoryLabelView!
    @IBOutlet weak var dayPriceIcon: UIImageView!
    @IBOutlet weak var dayPriceLabel: UILabel!

    @IBOutlet weak var nightPriceIcon: UIImageView!
    @IBOutlet weak var nightPriceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var reviewIcon: UIImageView!
    @IBOutlet weak var reviewCommentLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    var restaurant = Restaurant()
    var syncID = ""
    var shopID = ""
    var shopName = ""
    var priceRange = ""
    var distance: Double = 0.0
    var imageUrls = [NSURL?]()
    var url: NSURL?
    var category = ""
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
        self.mainImageView.contentMode = .Redraw
        self.secondImageView.image = UIImage(named: "noimage")
        self.secondImageView.contentMode = .Redraw
        self.thirdImageView.image = UIImage(named: "noimage")
        self.thirdImageView.contentMode = .Redraw
        
        // レストラン名のラベル
        self.restaurantNameLabel.text = self.shopName
        self.restaurantNameLabel.backgroundColor = UIColor.whiteColor()
        self.restaurantNameLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 16)
        self.restaurantNameLabel.numberOfLines = 2
        self.restaurantNameLabel.textColor = Const.RANKING_TOP_COLOR
        self.restaurantNameLabel.sizeToFit()
        
        // カテゴリ
        self.categoryView.setCategory(self.category)
        self.categoryView.backgroundColor = Const.RANKING_TOP_COLOR
        
        self.dayPriceIcon.image = UIImage(named: "noimage")
        // 値段ラベル
        self.dayPriceLabel.text = Utils.formatPriceString(self.priceRange)
        self.dayPriceLabel.numberOfLines = 2
        self.dayPriceLabel.sizeToFit()
        self.dayPriceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.dayPriceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        
        self.nightPriceIcon.image = UIImage(named: "noimage")
        self.nightPriceLabel.text = Utils.formatPriceString(self.priceRange)
        self.nightPriceLabel.numberOfLines = 2
        self.nightPriceLabel.sizeToFit()
        self.nightPriceLabel.textColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        self.nightPriceLabel.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 12)
        
        // 距離ラベル
        self.distanceLabel.text = String(format: NSLocalizedString("CardDistanceFromText", comment: ""), self.distance.meterToMinutes())
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
        self.separator.backgroundColor = UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0)
        
        // レビューアイコン
        self.reviewIcon.image = UIImage(named: "second")

        self.reviewCommentLabel.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        self.reviewCommentLabel.textColor = Const.KARUTA_THEME_TEXT_COLOR
        self.reviewCommentLabel.text = "testてすとテストやで"
        
        // もっと見るボタン
        self.detailButton.backgroundColor = Const.RANKING_TOP_COLOR
        self.detailButton.addTarget(self, action: "resultTapped:", forControlEvents: .TouchUpInside)
        self.detailButton.setTitle(NSLocalizedString("ResultShowDetail", comment: ""), forState: .Normal)
        
        // 画像のダウンロード
        self.acquireImages()
        
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.gradientLayer.frame = self.mapView.layer.bounds
    }
    
    // TODO: - Refactoring
    private func acquireImages() {
        if self.imageUrls.count <= 0 {
            
        } else if self.imageUrls.count == 1 {
            self.mainImageView.sd_setImageWithURL(self.imageUrls[0], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.mainImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.mainImageView.alpha = 1
                    }, completion: nil)
                })
        } else if self.imageUrls.count == 2 {
            self.mainImageView.sd_setImageWithURL(self.imageUrls[0], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.mainImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.mainImageView.alpha = 1
                    }, completion: nil)
                })
            self.secondImageView.sd_setImageWithURL(self.imageUrls[1], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.secondImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.secondImageView.alpha = 1
                    }, completion: nil)
                })
        } else {
            self.mainImageView.sd_setImageWithURL(self.imageUrls[0], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.mainImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.mainImageView.alpha = 1
                    }, completion: nil)
                })
            self.secondImageView.sd_setImageWithURL(self.imageUrls[1], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.secondImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.secondImageView.alpha = 1
                    }, completion: nil)
                })
            self.thirdImageView.sd_setImageWithURL(self.imageUrls[2], completed: {[weak self](image: UIImage!, error: NSError!, cacheType: SDImageCacheType, imageURL: NSURL!) in
                self!.thirdImageView.alpha = 0
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: {() -> Void in
                    self!.thirdImageView.alpha = 1
                    }, completion: nil)
                })
        }
    }
    
    func resultTapped(sender: AnyObject) {
        self.delegate!.detailButtonTapped(self.restaurant)
    }
}
