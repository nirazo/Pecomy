//
//  MainViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MDCSwipeToChoose
import SnapKit

class MainViewController: UIViewController, MDCSwipeToChooseDelegate, KarutaLocationManagerProtocol {

    let locationManager: KarutaLocationManager = KarutaLocationManager()
    
    var contentView = UIView()
    
    var isLocationAcquired = false
    var canCallNextCard = true
    var stackedCards = [CardView]()
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterForeground:", name:"applicationWillEnterForeground", object: nil)
        
        self.navigationItem.title = Const.KARUTA_TITLE
        
        // 背景画像設定（とりあえず固定で...）
        var image = UIImage(named: "background")
        UIGraphicsBeginImageContext(self.view.frame.size);
        image!.drawInRect(self.view.bounds)
        var backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        // カードを配置するための透明ビュー
        contentView.frame = self.view.frame
        contentView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.contentView)
        
        // フッター
        var footerBar = UIView(frame: CGRectZero)
        footerBar.backgroundColor = Const.KARUTA_THEME_TEXT_COLOR
        var footerText = UILabel(frame: CGRectZero)
        footerText.text = NSLocalizedString("SearchingRestaurant", comment: "")
        footerText.textColor = Const.KARUTA_THEME_COLOR
        footerText.textAlignment = .Center
        
        self.view.addSubview(footerBar)
        footerBar.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.07)
            make.bottom.equalTo(self.view)
        }
        
        footerBar.addSubview(footerText)
        footerText.snp_makeConstraints { (make) in
            make.width.equalTo(footerBar)
            make.height.equalTo(footerBar)
            make.center.equalTo(footerBar)
        }

        // ボタン配置
        var likeButton = UIButton()
        likeButton.setImage(UIImage(named: "like_normal"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like_tapped"), forState: .Highlighted)
        likeButton.addTarget(self, action: "likeButtonTapped", forControlEvents: .TouchUpInside)
        
        var dislikeButton = UIButton()
        dislikeButton.setImage(UIImage(named: "dislike_normal"), forState: .Normal)
        dislikeButton.setImage(UIImage(named: "dislike_tapped"), forState: .Highlighted)
        dislikeButton.addTarget(self, action: "dislikeButtonTapped", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(likeButton)
        self.view.addSubview(dislikeButton)
        
        dislikeButton.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).multipliedBy(0.25)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.25)
            make.centerX.equalTo(self.view).offset(-self.view.frame.width/4)
            make.bottom.equalTo(footerBar.snp_top).offset(-20)
        }
        
        likeButton.snp_makeConstraints { (make) in
            make.width.equalTo(dislikeButton)
            make.height.equalTo(dislikeButton)
            make.centerX.equalTo(self.view).offset(self.view.frame.width/4)
            make.bottom.equalTo(dislikeButton)
        }
        
        self.acquireFirstCard()
    }
    
    // observer
    func enterForeground(notification: NSNotification){
        if self.currentLatitude == nil || self.currentLongitude == nil {
            println("enterrrrrr")
            self.acquireFirstCard()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Card related methods
    func acquireFirstCard() {
        self.locationManager.delegate = self
        self.locationManager.fetchWithCompletion({ (location) in
            println("success!!")
            self.currentLatitude = Double(location!.coordinate.latitude);
            self.currentLongitude = Double(location!.coordinate.longitude);
            
            self.acquireCardWithLatitude(Double(self.currentLatitude!),
                longitude: Double(self.currentLongitude!),
                like: nil,
                syncId: nil,
                reset: true,
                success: {(Bool) in
                    // とりあえず直で2回呼びます
                    self.acquireCardWithLatitude(Double(self.currentLatitude!),
                        longitude: Double(self.currentLongitude!),
                        like: nil,
                        syncId: nil,
                        reset: false,
                        success: {(Bool) in
                            
                        }
                        ,
                        failure: {(NSError) in
                        }
                    )
                }
                ,
                failure: {(NSError) in
                }
            )
        }, failure: { (error) in
            self.showRetryToGetLocationAlert()
        })
    }
    
    /**
    カードを取得
    */
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String?, syncId: String?, reset: Bool, success: (Bool)->(), failure: (NSError)->()) -> Bool {
        var params: Dictionary<String, AnyObject> = [
            "device_id" : Const.DEVICE_ID,
            "latitude" : latitude,
            "longitude" : longitude,
            "reset" : reset
        ]
        
        if (syncId != nil) {
            params.updateValue(syncId!, forKey: "sync_id")
        }
        if ((like) != nil) {
            params.updateValue(like!, forKey: "answer")
        }
        
        var hasResult = false;
        
        Alamofire.request(.GET, Const.API_CARD_BASE, parameters: params, encoding: .URL).responseJSON {(request, response, data, error) in
            var json = JSON.nullJSON
            if error == nil && data != nil {
                json = SwiftyJSON.JSON(data!)
                // 店が見つかった場合
                println("response data: \(json)")
                if (json["message"] == nil) {
                    let card: JSON = json["card"]
                    
                    let shopID: String = card["shop_id"].stringValue
                    let shopName = card["title"].string!
                    
                    let shopImageUrlsString = card["image_url"].array!
                    let priceRange = card["price_range"].string!
                    let distance: Double = card["distance_meter"].double!
                    
                    var shopImageUrls = [NSURL]()
                    for urlString in shopImageUrlsString {
                        shopImageUrls.append(NSURL(string: urlString.string!)!)
                    }
                    
                    let url = NSURL(string: card["url"].string!)
                    
                    let syncID: String! = json["sync_id"].string!
                    
                    let restaurant = Restaurant(shopID: shopID, shopName: shopName, priceRange: priceRange, distance: distance, imageUrls: shopImageUrls, url: url!)
                    
                    let cardView = self.createCardWithFrame(self.baseCardRect(), restaurant: restaurant, syncID: syncID)
                    
                    self.stackedCards.append(cardView)
                    
                    // カード取得・表示については2枚取得する際に変更
                    self.displayStackedCard()
                    
                    hasResult = json["result_available"].bool!
                    success(hasResult)
                } else {
                    println("cannot find!")
                }
            
            println("url: \(request)")
            
            } else {
                println("fail to get card")
                failure(error!)
            }
        }
        return hasResult
    }
    
    // カードを表示
    func displayStackedCard() {
        for card in self.stackedCards {
            card.bounds.origin.y = card.bounds.origin.y - self.cardOffsetY()
            card.alpha = 0
            self.contentView.addSubview(card)
            self.contentView.sendSubviewToBack(card)
            UIView.animateWithDuration(0.3,
                animations: {
                    card.alpha = 1
                }) { finished in
            }

        }
        self.stackedCards.removeAll()
    }
    
    // カードを作成
    func createCardWithFrame(frame: CGRect, restaurant: Restaurant, syncID: String) -> CardView {
        var options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.onPan = { [weak self] state in
                if(self!.numOfDisplayedCard() > 1){
                    var frame:CGRect = self!.baseCardRect()
                    var secondCard = self!.contentView.subviews[0] as! CardView
                    secondCard.frame = CGRect(x: frame.origin.x, y: frame.origin.y-(state.thresholdRatio * 10.0), width: CGRectGetWidth(frame), height: CGRectGetHeight(frame))
                }

        }
        let cardView = CardView(frame: frame, restaurant: restaurant, syncID:syncID, options: options)
        return cardView
    }
    
    // カード全部消す
    func resetCards() {
        for cv in self.contentView.subviews {
            if cv.dynamicType === CardView.self {
                cv.removeFromSuperview()
            }
        }
    }
    
    // カードの枚数に応じてカードのオフセットを返す
    func cardOffsetY() -> CGFloat {
        var offset: CGFloat = 0
        for cv in self.contentView.subviews {
            if cv.dynamicType === CardView.self {
                offset += 10
            }
        }
        return offset
    }
        
    // 表示されてるカードの枚数を返す
    func numOfDisplayedCard() -> Int {
        var num = 0
        for cv in self.contentView.subviews {
            if cv.dynamicType === CardView.self {
                num++
            }
        }
        return num
    }
    
    // カードのベースとなるCGRectを返す
    func baseCardRect() -> CGRect{
        var rect = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: self.view.frame.height*0.6)
        rect.offset(dx: (self.view.frame.width - rect.size.width)/2, dy: (self.view.frame.height - rect.size.height)/2 - 40)
        return rect
    }
    
    
    //MARK: - Result related methods
    
    /**
    結果（ここへ行け！リスト）を取得
    */
    func acquireResults() {
        var params: Dictionary<String, AnyObject> = [
            "device_id": Const.DEVICE_ID,
            "latitude" : self.currentLatitude!,
            "longitude" : self.currentLongitude!
        ]
        
        Alamofire.request(.GET, Const.API_RESULT_BASE, parameters: params, encoding: .URL).responseJSON {(request, response, data, error) in
            var json = JSON.nullJSON
            if error == nil && data != nil {
                json = SwiftyJSON.JSON(data!)
                let results = json["results"]
                
                // Restaurantクラスを生成
                var restaurants = [Restaurant]()
                for i in 0..<results.count {
                    let shopID = results[i]["shop_id"].stringValue
                    let shopName = results[i]["title"].string!
                    let shopImageUrlsString = results[i]["image_url"].array!
                    let priceRange = results[i]["price_range"].string!
                    let distance: Double = results[i]["distance_meter"].double!
                    let url = NSURL(string: results[i]["url"].string!)
                    
                    var shopImageUrls = [NSURL]()
                    for urlString in shopImageUrlsString {
                        shopImageUrls.append(NSURL(string: urlString.string!)!)
                    }
                    
                    restaurants.append(Restaurant(shopID: shopID, shopName: shopName, priceRange: priceRange, distance: distance, imageUrls: shopImageUrls, url: url!))
                }
                
                println("call present result!!")
                println("restaurants: \(restaurants.count)")
                self.displayResultViewWithShopList(restaurants)
            } else {
                println("failed to get result!!")
            }
        }
    }
    
    func displayResultViewWithShopList(restaurants: [Restaurant]) {
        var resultVC = ResultViewController(restaurants: restaurants)
        let backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        resultVC.navigationItem.title = "あなたのBEST"
        
        // カードリセットしてnew card呼び出し
        self.resetCards()
        self.acquireFirstCard()
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    

    func closeResult() {
        self.resetCards()
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: nil, syncId: nil, reset: true, success: {(hasResult: Bool) in
            if (hasResult) {
                self.acquireResults()
            }
        },
            failure: {(error: NSError) in
        }
        )
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Button tapped Callbacks
    func likeButtonTapped() {
        self.swipeTopCardToWithDirection(.Right)
    }
    
    func dislikeButtonTapped() {
        self.swipeTopCardToWithDirection(.Left)
    }
    
    func swipeTopCardToWithDirection(direction: MDCSwipeDirection) {
        if (self.contentView.subviews.count > 0) {
            var card = self.contentView.subviews[self.contentView.subviews.count-1] as! CardView
            card.mdc_swipe(direction)
        }
    }
    
    
    //MARK: - MDCSwipeToChooseDelegate Callbacks
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(view: UIView!) {
        println("Couldn't decide, huh?")
    }
    
    // Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
    func view(view: UIView!, shouldBeChosenWithDirection direction: MDCSwipeDirection) -> Bool {
        if (direction == .Left || direction == .Right) {
            return true
        } else {
            UIView.animateWithDuration(0.16, animations: {() in
                view.transform = CGAffineTransformIdentity
                view.center = view.superview!.center
            })
            return false
        }
    }
    
    
    // This is called then a user swipes the view fully left or right.
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        var answer = "dislike"
        if (direction == .Right) {
            answer = "like"
        }
        var cardView = view as! CardView
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: answer, syncId: cardView.syncID, reset: false,
            success: {(hasResult: Bool) in
                if (hasResult) {
                    self.acquireResults()
                }
            }, failure: {(error: NSError) in
            }
        )
    }
    
    // 位置情報取得リトライのアラート表示
    func showRetryToGetLocationAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("LocationRetryAlertTitle", comment: ""),
            message: NSLocalizedString("LocationRetryAlertMessage", comment: ""),
            preferredStyle: .Alert)
        let retryAction = UIAlertAction(title: NSLocalizedString("LocationRetryAlertRetryButtonTitle", comment: ""),
            style: .Default, handler: { (action) in
                self.acquireFirstCard()
        })
        alertController.addAction(retryAction)
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    //MARK: - KarutaLocationProtocol
    func showLocationEnableAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("LocationAlertTitle", comment: ""),
            message: NSLocalizedString("LocationAlertMessage", comment: ""),
            preferredStyle: .Alert)
        let settingAction = UIAlertAction(title: NSLocalizedString("LocationAlertSettingButtonTitle", comment: ""),
            style: .Default, handler: { (action) in
                let url = NSURL(string: UIApplicationOpenSettingsURLString)
                UIApplication.sharedApplication().openURL(url!)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("LocationAlertCancelButtonTitle", comment: ""),
            style: .Default, handler: nil)
        
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}

