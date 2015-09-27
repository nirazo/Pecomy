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

class MainViewController: UIViewController, MDCSwipeToChooseDelegate, KarutaLocationManagerDelegate {
    
    let PROGRESS_HEIGHT: CGFloat = 8.0
    let FOOTER_HEIGHT: CGFloat = 34.0
    
    // like, dislikeのスワイプ増分
    let INCREMENT_LIKE: Float = 0.125
    let INCREMENT_DISLIKE: Float = 0.05
    
    let locationManager = KarutaLocationManager()
    let progressViewController = CardProgressViewController()
    
    let contentView = UIView()
    
    var isLocationAcquired = false
    var canCallNextCard = true
    var stackedCards = [CardView]()
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    var isResultDisplayedOnce = false
    
    var currentProgress: Float = 0.0
    
    let loadingIndicator = UIActivityIndicatorView()
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterForeground:", name:Const.WILL_ENTER_FOREGROUND_KEY, object: nil)
        
        self.navigationItem.title = Const.KARUTA_TITLE
        
        // 背景画像設定（とりあえず固定で...）
        let image = UIImage(named: "background")
        UIGraphicsBeginImageContext(self.view.frame.size);
        image!.drawInRect(self.view.bounds)
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        // カードを配置するための透明ビュー
        contentView.frame = self.view.frame
        contentView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.contentView)
        
        // フッター
        let footerBar = UIView(frame: CGRectZero)
        footerBar.backgroundColor = Const.KARUTA_THEME_TEXT_COLOR
        let footerText = UILabel(frame: CGRectZero)
        footerText.text = NSLocalizedString("SearchingRestaurant", comment: "")
        footerText.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 12)
        footerText.textColor = Const.KARUTA_THEME_COLOR
        footerText.textAlignment = .Center
        
        self.view.addSubview(footerBar)
        footerBar.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.height.equalTo(FOOTER_HEIGHT)
            make.bottom.equalTo(self.view).offset(-PROGRESS_HEIGHT)
        }
        
        footerBar.addSubview(footerText)
        footerText.snp_makeConstraints { (make) in
            make.width.equalTo(footerBar)
            make.height.equalTo(footerBar)
            make.center.equalTo(footerBar)
        }
        
        // プログレスバー
        self.addChildViewController(self.progressViewController)
        self.progressViewController.didMoveToParentViewController(self)
        
        self.view.addSubview(self.progressViewController.view)
        self.progressViewController.view.snp_makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.top.equalTo(footerBar.snp_bottom)
            make.bottom.equalTo(self.view)
        }
        
        // ボタン配置
        let likeButton = UIButton()
        likeButton.setImage(UIImage(named: "like_normal"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like_tapped"), forState: .Highlighted)
        likeButton.addTarget(self, action: "likeButtonTapped", forControlEvents: .TouchUpInside)
        
        let dislikeButton = UIButton()
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
        
        // インジケータ
        self.loadingIndicator.bounds = CGRectMake(0.0, 0.0, 50, 50)
        self.loadingIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(self.loadingIndicator)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (self.currentLatitude == nil || self.currentLongitude == nil) {
            self.acquireFirstCard()
        }
    }
    
    // observer
    func enterForeground(notification: NSNotification){
        if self.currentLatitude == nil || self.currentLongitude == nil {
            self.acquireFirstCard()
        } else {
            // 前回実施時の距離から特定の距離以上離れていたらポップアップを出してリトライ
            let loadingView = LoadingView(frame: CGRectZero)
            self.view.addSubview(loadingView)
            loadingView.snp_makeConstraints { (make) in
                make.width.equalTo(self.view)
                make.height.equalTo(self.view)
                make.centerX.equalTo(self.view)
            }
            
            self.locationManager.fetchWithCompletion({ [weak self] (location) in
                loadingView.removeFromSuperview()
                if (Utils.distanceBetweenLocations(self!.currentLatitude!, fromLon: self!.currentLongitude!, toLat: location!.coordinate.latitude, toLon: location!.coordinate.longitude) > Const.RETRY_DISTANCE) {
                    self?.reset()
                    self!.currentLatitude = Double(location!.coordinate.latitude);
                    self!.currentLongitude = Double(location!.coordinate.longitude);
                    self?.acquireFirstCardsWithLocation(self!.currentLatitude!, longitude: self!.currentLongitude!)
                }
                
                }, failure: { (error) in
                self.showRetryToGetLocationAlert()
            })
        }
    }
    
    func reset() {
        self.isLocationAcquired = false
        self.isResultDisplayedOnce = false
        self.resetCards()
        self.currentLatitude = nil
        self.currentLongitude = nil
        self.currentProgress = 0.0
        self.progressViewController.reset()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Card related methods
    func acquireFirstCard() {
        self.locationManager.delegate = self
        self.locationManager.fetchWithCompletion({ [weak self] (location) in
            self!.currentLatitude = Double(location!.coordinate.latitude);
            self!.currentLongitude = Double(location!.coordinate.longitude);
            self?.acquireFirstCardsWithLocation(self!.currentLatitude!, longitude: self!.currentLongitude!)
            },
            failure: { (error) in
            self.showRetryToGetLocationAlert()
        })
    }
    
    func acquireFirstCardsWithLocation(latitude: Double, longitude: Double) {
        self.acquireCardWithLatitude(latitude,
            longitude: longitude,
            reset: true,
            success: {(Bool) in
                // とりあえず直で2回呼びます
                self.acquireCardWithLatitude(latitude,
                    longitude: longitude,
                    reset: false
                )
            }
            ,
            failure: {(NSError) in
            }
        )
    }
    
    /**
    カードを取得
    */
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String? = nil, syncId: String? = nil, reset: Bool, success: (Bool)->() = {(Bool) in}, failure: (ErrorType)->() = {(ErrorType) in}) {
        var params: Dictionary<String, AnyObject> = [
            "device_id" : Utils.acquireDeviceID(),
            "latitude" : latitude,
            "longitude" : longitude,
            "reset" : reset
        ]
        
        if (syncId != nil) {
            params["sync_id"] = syncId!
        }
        if ((like) != nil) {
            params["answer"] = like!
        }
        
        var hasResult = false;
        
        //インジケータ表示
        self.showIndicator()
        
        Alamofire.request(.GET, Const.API_CARD_BASE, parameters: params, encoding: .URL).responseJSON {[weak self](request, response, result) in
            
            // インジケータ消す
            self?.hideIndicator()
            
            var json = JSON.nullJSON
            
            switch result {
            case .Success(let data):
                json = SwiftyJSON.JSON(data)
                // 店が見つかった場合
                if (response?.statusCode == Const.STATUS_CODE_SUCCESS) {
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
                    
                    let cardView = self!.createCardWithFrame(self!.baseCardRect(), restaurant: restaurant, syncID: syncID)
                    
                    self!.stackedCards.append(cardView)
                    
                    self!.displayStackedCard()
                    
                    hasResult = json["result_available"].bool!
                    success(hasResult)
                } else if (response?.statusCode == Const.STATUS_CODE_NOT_FOUND) { // カードが見つからない
                    let resetFlg = params["reset"] as! Bool
                    if (resetFlg) {
                        self!.showOutOfRangeAlert()
                    } else {
                        if (!self!.isResultDisplayedOnce) {
                            self!.acquireResults()
                        }
                    }
                } else if (response?.statusCode == Const.STATUS_CODE_SERVER_ERROR) { // サーバエラー
                    self?.showServerErrorAlert()
                } else {
                    self!.acquireResults()
                }
            case .Failure(_, let error):
                failure(error)
            }
        }
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
        let options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.onPan = { [weak self] state in
            if(self!.numOfDisplayedCard() > 1){
                let frame:CGRect = self!.baseCardRect()
                let secondCard = self!.contentView.subviews[0] as! CardView
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
                offset += 6
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
        rect.offsetInPlace(dx: (self.view.frame.width - rect.size.width)/2, dy: (self.view.frame.height - rect.size.height)/2 - 40)
        return rect
    }
    
    
    //MARK: - Result related methods
    
    /**
    結果（ここへ行け！リスト）を取得
    */
    func acquireResults() {
        self.isResultDisplayedOnce = true
        
        let params: Dictionary<String, AnyObject> = [
            "device_id": Utils.acquireDeviceID(),
            "latitude" : self.currentLatitude!,
            "longitude" : self.currentLongitude!
        ]
        Alamofire.request(.GET, Const.API_RESULT_BASE, parameters: params, encoding: .URL).responseJSON {[weak self](request, response, result) in
            var json = JSON.nullJSON
            switch result {
            case .Success(let data):
                json = SwiftyJSON.JSON(data)
                
                // Restaurantクラスを生成
                var restaurants = [Restaurant]()
                
                if (response?.statusCode == Const.STATUS_CODE_SUCCESS) {
                    let results = json["results"]
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
                } else if (response?.statusCode == Const.STATUS_CODE_NOT_FOUND) {
                    // nothing（404の場合、空配列をresultVCに渡し、0件時と同様に処理する）
                } else if (response?.statusCode == Const.STATUS_CODE_SERVER_ERROR) {
                    self?.showServerErrorAlert()
                    break
                }
                // 結果表示
                self!.displayResultViewWithShopList(restaurants)
                
            case .Failure(_):
                self?.showServerErrorAlert()
            }
        }
    }
    
    func displayResultViewWithShopList(restaurants: [Restaurant]) {
        let resultVC = ResultViewController(restaurants: restaurants)
        let backButton = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        resultVC.navigationItem.title = NSLocalizedString("YourBest", comment: "")
        
        self.reset()
        
        if (self.navigationController?.viewControllers.count == 1) {
            self.navigationController?.pushViewController(resultVC, animated: true)
        }
    }
    
    //MARK: - Button tapped Callbacks
    func likeButtonTapped() {
        self.swipeTopCardToWithDirection(.Right)
    }
    
    func dislikeButtonTapped() {
        self.swipeTopCardToWithDirection(.Left)
    }
    
    func swipeTopCardToWithDirection(direction: MDCSwipeDirection) {
        if (self.numOfDisplayedCard() > 0) {
            let card = self.contentView.subviews[self.contentView.subviews.count-1] as! CardView
            if (!card.isFlicked) {
                card.isFlicked = true
                card.mdc_swipe(direction)
            }
        }
    }
    
    
    //MARK: - MDCSwipeToChooseDelegate Callbacks
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(view: UIView!) {
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
        let cardView = view as! CardView
        cardView.isFlicked = true
        
        var answer = "dislike"
        if (direction == .Right) {
            answer = "like"
            self.currentProgress += INCREMENT_LIKE
            self.progressViewController.progressWithRatio(self.currentProgress)
        } else {
            self.currentProgress += INCREMENT_DISLIKE
            self.progressViewController.progressWithRatio(self.currentProgress)
        }
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: answer, syncId: cardView.syncID, reset: false,
            success: {[weak self](hasResult: Bool) in
                if (hasResult) {
                    if (!self!.isResultDisplayedOnce) {
                        self!.acquireResults()
                    }
                }
            }, failure: {(error: ErrorType) in
            }
        )
    }
    
    //MARK: - Alerts
    // アプリの対象範囲外アラート表示
    func showOutOfRangeAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("OutOfRangeAlertTitle", comment: ""),
            message: NSLocalizedString("OutOfRangeAlertMessage", comment: ""),
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    // 位置情報取得リトライのアラート表示
    func showRetryToGetLocationAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("LocationRetryAlertTitle", comment: ""),
            message: NSLocalizedString("LocationRetryAlertMessage", comment: ""),
            preferredStyle: .Alert)
        let retryAction = UIAlertAction(title: NSLocalizedString("LocationRetryAlertRetryButtonTitle", comment: ""),
            style: .Default, handler: { [weak self](action) in
                self!.acquireFirstCard()
            })
        alertController.addAction(retryAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // サーバエラー時のアラート表示
    func showServerErrorAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("ServerErrorAlertTitle", comment: ""),
            message: NSLocalizedString("ServerErrorAlertMessage", comment: ""),
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .Default, handler: { [weak self](action) in
                self!.acquireFirstCard()
            })
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: - Indicators
    func showIndicator() {
        if (self.numOfDisplayedCard() == 0) {
            self.loadingIndicator.startAnimating()
        }
    }
    
    func hideIndicator() {
        self.loadingIndicator.stopAnimating()
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

