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

class MainViewController: UIViewController, MDCSwipeToChooseDelegate, KarutaLocationManagerDelegate, CardViewDelegate, ResultViewControllerDelegate, CategorySelectionViewControllerDelegate {
    
    let ANALYTICS_TRACKING_CODE = AnaylyticsTrackingCode.MainViewController.rawValue
    
    let PROGRESS_HEIGHT: CGFloat = 8.0
    let FOOTER_HEIGHT: CGFloat = 34.0
    
    // like, dislikeのスワイプ増分
    let INCREMENT_LIKE: Float = 0.16
    let INCREMENT_DISLIKE: Float = 0.10
    
    // 結果表示後、何枚めくったら再度結果を出すか(2枚先出しするので実際の数-2っす)
    let SWIPE_COUNT_TO_RESULT = 3
    
    // 現在のスワイプ数（結果画面行ったらリセット）
    var currentSwipeCount = 0
    
    let locationManager = KarutaLocationManager()
    let progressViewController = CardProgressViewController()
    
    let contentView = UIView()
    
    // TODO: これ以上フラグは増やしたくない
    var isLocationAcquired = false
    var canDisplayNextCard = true
    var isDisplayedResult = false
    
    // Model
    var restaurantModel = RestaurantModel()
    var resultModel = ResultModel()
    
    var stackedCards = [CardView]()
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    var currentCategory = CategoryIdentifier.All
    
    var currentProgress: Float = 0.0
    
    let loadingIndicator = UIActivityIndicatorView()
    
    // ビュー関連
    var categoryLabelView: CategoryLabelView?
    
    // 現在選択されているカテゴリ
    var selectedCategory = CategoryIdentifier.All.valueForDisplay()
    
    var categorySelectionVC: CategorySelectionViewController?

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
        
        // カテゴリ
        self.categoryLabelView = CategoryLabelView(frame: CGRectZero, category: self.selectedCategory)
        self.view.addSubview(self.categoryLabelView!)
        let tr = UITapGestureRecognizer(target: self, action: "categoryTapped:")
        self.categoryLabelView!.addGestureRecognizer(tr)
        
        self.categoryLabelView!.snp_makeConstraints { (make) in
            make.left.equalTo(dislikeButton.snp_right)
            make.right.equalTo(likeButton.snp_left)
            make.top.equalTo(likeButton.snp_bottom).inset(30)
            make.bottom.equalTo(footerBar.snp_top).inset(-5)
        }
        
        
        // インジケータ
        self.loadingIndicator.bounds = CGRectMake(0.0, 0.0, 50, 50)
        self.loadingIndicator.activityIndicatorViewStyle = .WhiteLarge
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(self.loadingIndicator)
        
        if (self.currentLatitude == nil || self.currentLongitude == nil) {
            self.acquireFirstCard()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.ANALYTICS_TRACKING_CODE)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    // observer
    func enterForeground(notification: NSNotification){
        if self.currentLatitude == nil || self.currentLongitude == nil {
            self.reset()
            self.acquireFirstCard()
        } else {
            // 前回実施時の距離から特定の距離以上離れていたらリトライ
            let loadingView = LoadingView(frame: CGRectZero)
            self.view.addSubview(loadingView)
            loadingView.snp_makeConstraints { (make) in
                make.width.equalTo(self.view)
                make.height.equalTo(self.view)
                make.centerX.equalTo(self.view)
            }
            
            self.locationManager.fetchWithCompletion({ [weak self] (location) in
                loadingView.removeFromSuperview()
                guard let strongSelf = self else {
                    return
                }
                if (Utils.distanceBetweenLocations(strongSelf.currentLatitude!, fromLon: strongSelf.currentLongitude!, toLat: location!.coordinate.latitude, toLon: location!.coordinate.longitude) > Const.RETRY_DISTANCE) {
                    strongSelf.reset()
                    strongSelf.currentLatitude = Double(location!.coordinate.latitude);
                    strongSelf.currentLongitude = Double(location!.coordinate.longitude);
                    strongSelf.acquireFirstCardsWithLocation(strongSelf.currentLatitude!, longitude: strongSelf.currentLongitude!)
                }
                
                }, failure: { [weak self] (error) in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.showRetryToGetLocationAlert()
                })
        }
    }
    
    //MARK: - Reset
    // 位置情報も含め、全てリセット
    func reset() {
        self.resetViews()
        self.isLocationAcquired = false
        self.currentLatitude = nil
        self.currentLongitude = nil
        self.stackedCards.removeAll()
    }
    
    // カード全部消す
    func resetCards() {
        for cv in self.contentView.subviews {
            if cv.dynamicType === CardView.self {
                cv.removeFromSuperview()
            }
        }
    }
    
    // 位置情報はそのままに、ビュー関連をリセット
    func resetViews() {
        self.resetCards()
        self.currentSwipeCount = 0
        self.currentProgress = 0.0
        self.progressViewController.reset()
        self.canDisplayNextCard = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Card related methods
    func acquireFirstCard() {
        self.locationManager.delegate = self
        self.locationManager.fetchWithCompletion({ [weak self] (location) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.currentLatitude = Double(location!.coordinate.latitude);
            strongSelf.currentLongitude = Double(location!.coordinate.longitude);
            strongSelf.acquireFirstCardsWithLocation(strongSelf.currentLatitude!, longitude: strongSelf.currentLongitude!)
            },
            failure: { [weak self] (error) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showRetryToGetLocationAlert()
            })
    }
    
    func acquireFirstCardsWithLocation(latitude: Double, longitude: Double) {
        self.acquireCardWithLatitude(latitude, longitude: longitude, category: self.currentCategory, reset: true,
            completion: { [weak self] (Bool) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.acquireCardWithLatitude(latitude, longitude: longitude, category: strongSelf.currentCategory, reset: false, completion: nil)
        })
    }
    
    /**
    カードを取得
    */
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String? = nil, category: CategoryIdentifier, syncId: String? = nil, reset: Bool, completion: ((Bool)->())? = nil) {
        self.showIndicator()
        self.restaurantModel.fetch(latitude, longitude: longitude, like: like, category: category, syncId: syncId, reset: reset, handler: {[weak self] (result: KarutaResult<Restaurant, KarutaApiClientError>) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideIndicator()
            
            switch result {
            case .Success(_):
                let cardView = strongSelf.createCardWithFrame(strongSelf.baseCardRect(), restaurant: strongSelf.restaurantModel.restaurant, syncID: strongSelf.restaurantModel.syncID)
                strongSelf.stackedCards.append(cardView)
                if (strongSelf.canDisplayNextCard) {
                    strongSelf.displayStackedCard()
                }
                
                let hasResult = strongSelf.restaurantModel.resultAvailable
                
                // result_availableがtrueで帰ってきた場合
                if (hasResult) {
                    if (!strongSelf.isDisplayedResult) {
                        strongSelf.canDisplayNextCard = false
                    } else {
                        if (strongSelf.currentSwipeCount >= strongSelf.SWIPE_COUNT_TO_RESULT) {
                            strongSelf.canDisplayNextCard = false
                        }
                    }
                }
                completion?(true)
            case .Failure(let error):
                switch error.type{
                case .NoResult:
                    if (reset) {
                        strongSelf.showOutOfRangeAlert()
                    } else {
                        strongSelf.acquireResults()
                    }
                case .ServerError:
                    strongSelf.showServerErrorAlert()
                default:
                    strongSelf.acquireResults()
                }
            }
        })
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
        cardView.delegate = self
        return cardView
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
        self.resultModel.fetch(self.currentLatitude!, longitude: self.currentLongitude!,
            handler: {[weak self] (result: KarutaResult<[Restaurant], KarutaApiClientError>) in
                guard let strongSelf = self else {
                    return
                }
                switch result {
                case .Success(let res):
                    strongSelf.displayResultViewWithShopList(res)
                case .Failure(let error):
                    switch error.type{
                    case .NoResult:
                        strongSelf.displayResultViewWithShopList([Restaurant]())
                    case .ServerError:
                        strongSelf.showServerErrorAlert()
                    default:
                        strongSelf.showServerErrorAlert()
                    }
                }
            }
        )
    }
    
    func displayResultViewWithShopList(restaurants: [Restaurant]) {
        let resultVC = ResultViewController(restaurants: restaurants)
        resultVC.delegate = self
        
        if (self.navigationController?.viewControllers.count == 1) {
            let navVC = UINavigationController(rootViewController: resultVC)
            resultVC.navigationItem.title = NSLocalizedString("ResultTitle", comment: "")
            self.isDisplayedResult = true
            self.presentViewController(navVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Button tapped Callbacks
    func likeButtonTapped() {
        self.swipeTopCardToWithDirection(.Right)
    }
    
    func dislikeButtonTapped() {
        self.swipeTopCardToWithDirection(.Left)
    }
    
    func categoryTapped(sender:UITapGestureRecognizer) {
        self.categorySelectionVC = CategorySelectionViewController()
        self.categorySelectionVC!.delegate = self
        self.view.addSubview(self.categorySelectionVC!.view)
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
    
    //MARK: - CategorySelectionViewControllerDelegate methods
    func closeButtonTapped() {
        if let vc = self.categorySelectionVC {
            vc.view.removeFromSuperview()
        }
        self.categorySelectionVC = nil
    }
    
    func categorySelected(category: CategoryIdentifier) {
        guard let categoryLabelView = self.categoryLabelView else {
            return
        }
        // set category
        self.currentCategory = category
        categoryLabelView.setCategory(category.valueForDisplay())
        
        if let vc = self.categorySelectionVC {
            vc.view.removeFromSuperview()
        }
        self.categorySelectionVC = nil
        
        // reset cards and request
        self.resetViews()
        
        if let lat = self.currentLatitude, lon = self.currentLongitude {
            self.acquireFirstCardsWithLocation(lat, longitude: lon)
        } else {
            self.acquireFirstCard()
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
        self.currentSwipeCount++
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

        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: answer, category:self.currentCategory, syncId: cardView.syncID, reset: false)
        if (!self.canDisplayNextCard && self.contentView.subviews.count == 0) {
            self.acquireResults()
        }
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
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
            style: .Default, handler: nil)
        
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - ResultViewControllerDelegate
    func resultViewController(controller: ResultViewController, backButtonTappedWithReset reset: Bool) {
        self.dismissViewControllerAnimated(true, completion: {[weak self]() in
            guard let strongSelf = self else {
                return
            }
            if reset {
                strongSelf.reset()
                strongSelf.acquireFirstCard()
            } else {
                strongSelf.resetViews()
                strongSelf.canDisplayNextCard = true
                strongSelf.displayStackedCard()
            }
        })
    }
    
    //MARK: - CardViewDelegate
    func blackListButtonTapped(card: CardView, shopID: String) {
        let ac = UIAlertController(title: "", message: NSLocalizedString("BlackListButtonSendMessage", comment: ""), preferredStyle: .Alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .Default, handler: { (action) in
                let params = ["shop_id": shopID, "device_id": Utils.acquireDeviceID()]
                Alamofire.request(.GET, Const.API_BLACKLIST_BASE, parameters: params, encoding: .URL).response {(httpRequest, httpResponse, data, error) in
                    // 現時点ではAPIが無いので、404を正とする
                    if (httpResponse!.statusCode == Const.STATUS_CODE_NOT_FOUND) {
                        card.blackListButton.enabled = false
                    }
                }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Back", comment: ""),
            style: .Default, handler: nil)
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
}