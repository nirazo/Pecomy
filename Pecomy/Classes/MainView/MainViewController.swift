//
//  MainViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MDCSwipeToChoose
import SnapKit

class MainViewController: UIViewController {
    static let title = Const.APP_TITLE
    
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
    
    let locationManager = PecomyLocationManager()
    let progressBar = GameProgressBar(frame: .zero)
    
    let contentView = UIView()
    
    // TODO: これ以上フラグは増やしたくない
    var isLocationAcquired = false
    var canDisplayNextCard = true
    var isDisplayedResult = false
    
    // Model
    var restaurantModel = RestaurantModel()
    var resultModel = ResultModel()
    
    var stackedCards = [CardView]()
    
    // var results
    var currentResults = [Restaurant]()
    
    // Tutorial
    var tutorialVC: TutorialViewController?

    // Onetime filter
    var currentBudget = Budget.unspecified
    var currentNumOfPeople = NumOfPeople.one
    var currentGenre = Genre.all
    
    var currentProgress: Float = 0.0
    
    var messageLabel = UILabel()
    
    let loadingIndicator = UIActivityIndicatorView()
    
    var onetimeFilterVC: OnetimeFilterViewController?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.makeNavigationBarTranslucent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.enterForeground(notification:)), name:NSNotification.Name(rawValue: Const.WILL_ENTER_FOREGROUND_KEY), object: nil)
        
        // カードを配置するための透明ビュー
        contentView.frame = self.view.bounds
        contentView.backgroundColor = UIColor.clear
        self.view.addSubview(self.contentView)
        
        // メッセージラベル
        self.messageLabel = UILabel(frame: .zero)
        self.messageLabel.text = NSLocalizedString("MainComment", comment: "")
        self.messageLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 22)
        self.messageLabel.textColor = UIColor.white
        self.messageLabel.textAlignment = .center
        self.view.addSubview(self.messageLabel)
        self.messageLabel.snp.makeConstraints { make in
            make.top.equalTo(self.view).offset(83)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(22)
        }
        
        // TODO: ビュー確認のため一時的に画面下部にビュー挿入。ほんとは引っ張る結果ビューが入る
        let resultView = UIView()
        
        // 結果ビュー
        resultView.backgroundColor = .white
        self.view.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.bottom.equalTo(self.view)
            make.height.equalTo(50)
            make.left.right.equalTo(self.view)
        }
        
        // 結果ビューラベル
        let label = UILabel()
        label.text = NSLocalizedString("SearchingRestaurant", comment: "")
        label.textColor = UIColor(red: 118.0/255.0, green: 118.0/255.0, blue: 118.0/255.0, alpha: 1.0)
        label.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 16)
        label.textAlignment = .center
        resultView.addSubview(label)
        label.snp.makeConstraints { make in
            make.size.equalTo(resultView)
            make.center.equalTo(resultView)
        }
        
        // プログレスバー
        self.view.addSubview(progressBar)
        self.progressBar.snp.makeConstraints { make in
            make.bottom.equalTo(resultView.snp.top).offset(-30)
            make.width.equalTo(self.contentView).multipliedBy(0.75)
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(10)
        }
        
        // ボタン配置
        let likeButton = UIButton()
        likeButton.setImage(R.image.like_normal(), for: .normal)
        likeButton.setImage(R.image.like_tapped(), for: .highlighted)
        likeButton.addTarget(self, action: #selector(MainViewController.likeButtonTapped), for: .touchUpInside)
        
        let reloadButton = UIButton()
        reloadButton.setImage(R.image.reload(), for: .normal)
        reloadButton.addTarget(self, action: #selector(MainViewController.reloadTapped), for: .touchUpInside)
        reloadButton.clipsToBounds = true
        reloadButton.layer.cornerRadius = reloadButton.frame.size.width * 0.5

        
        let dislikeButton = UIButton()
        dislikeButton.setImage(R.image.dislike_normal(), for: .normal)
        dislikeButton.setImage(R.image.dislike_tapped(), for: .highlighted)
        dislikeButton.addTarget(self, action: #selector(MainViewController.dislikeButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(likeButton)
        self.view.addSubview(dislikeButton)
        self.view.addSubview(reloadButton)
        
        dislikeButton.snp.makeConstraints { (make) in
            make.width.equalTo(self.view).multipliedBy(0.25)
            make.height.equalTo(self.view.snp.width).multipliedBy(0.25)
            make.centerX.equalTo(self.view).offset(-self.view.frame.width/4)
            make.bottom.equalTo(self.progressBar.snp.top).offset(-20)
        }
        
        likeButton.snp.makeConstraints { (make) in
            make.width.equalTo(dislikeButton)
            make.height.equalTo(dislikeButton)
            make.centerX.equalTo(self.view).offset(self.view.frame.width/4)
            make.bottom.equalTo(dislikeButton)
        }
        
        reloadButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(likeButton)
            make.width.equalTo(likeButton)//.multipliedBy(2/3)
            make.height.equalTo(likeButton)//.multipliedBy(2/3)
        }
        
        // インジケータ
        self.loadingIndicator.bounds = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        self.loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        self.loadingIndicator.center = self.view.center
        self.loadingIndicator.hidesWhenStopped = true
        self.view.addSubview(self.loadingIndicator)
        
        // 初回起動のときはtutorial出す
        if (!UserDefaults.standard.bool(forKey: Const.UD_KEY_HAS_LAUNCHED)) {
            KeychainManager.removePecomyUserToken()
            self.tutorialVC = TutorialViewController()
            self.tutorialVC?.delegate = self
            self.present(tutorialVC!, animated: true, completion: nil)
        } else {
            if (AppState.sharedInstance.currentLatitude == nil || AppState.sharedInstance.currentLongitude == nil) {
                self.displayOnetimeFilterView()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
//        let tracker = GAI.sharedInstance().defaultTracker
//        tracker?.set(kGAIScreenName, value: self.ANALYTICS_TRACKING_CODE)
//        
//        let builder = GAIDictionaryBuilder.createScreenView()
//        tracker?.send(builder?.build() as [NSObject : AnyObject])
    }
    
    //MARK:- Observer
    func enterForeground(notification: NSNotification){
        if AppState.sharedInstance.currentLatitude == nil || AppState.sharedInstance.currentLongitude == nil {
            self.reset()
            self.acquireFirstCard()
        } else {
            // 前回実施時の距離から特定の距離以上離れていたらリトライ
            let loadingView = LoadingView(frame: .zero)
            self.view.addSubview(loadingView)
            loadingView.snp.makeConstraints { (make) in
                make.width.equalTo(self.view)
                make.height.equalTo(self.view)
                make.centerX.equalTo(self.view)
            }
            
            self.locationManager.fetchWithCompletion({ [weak self] (location) in
                loadingView.removeFromSuperview()
                guard let strongSelf = self else {
                    return
                }
                if (Utils.distanceBetweenLocations(AppState.sharedInstance.currentLatitude!, fromLon: AppState.sharedInstance.currentLongitude!, toLat: location!.coordinate.latitude, toLon: location!.coordinate.longitude) > Const.RETRY_DISTANCE) {
                    strongSelf.reset()
                    AppState.sharedInstance.currentLatitude = Double(location!.coordinate.latitude);
                    AppState.sharedInstance.currentLongitude = Double(location!.coordinate.longitude);
                    strongSelf.acquireFirstCardsWithLocation(latitude: AppState.sharedInstance.currentLatitude!, longitude: AppState.sharedInstance.currentLongitude!)
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
        AppState.sharedInstance.currentLatitude = nil
        AppState.sharedInstance.currentLongitude = nil
        self.currentBudget = Budget.unspecified
        self.currentNumOfPeople = NumOfPeople.one
        self.currentGenre = Genre.all
        self.stackedCards.removeAll()
    }
    
    // カード全部消す
    func resetCards() {
        for cv in self.contentView.subviews {
            if type(of: cv) === CardView.self {
                cv.removeFromSuperview()
            }
        }
    }
    
    // 位置情報はそのままに、ビュー関連をリセット
    func resetViews() {
        self.resetCards()
        self.currentSwipeCount = 0
        self.currentProgress = 0.0
        self.progressBar.reset()
        self.canDisplayNextCard = true
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Onetime filter related method
    func displayOnetimeFilterView() {
        self.onetimeFilterVC = OnetimeFilterViewController(budget: self.currentBudget, numOfPeople: self.currentNumOfPeople, genre: self.currentGenre, enableCancel: false)
        self.onetimeFilterVC!.delegate = self
        UIApplication.shared.keyWindow?.addSubview(self.onetimeFilterVC!.view)
    }
    
    // MARK: - Card related methods
    func acquireFirstCard() {
        self.locationManager.delegate = self
        self.locationManager.fetchWithCompletion({ [weak self] (location) in
            guard let strongSelf = self else {
                return
            }
            AppState.sharedInstance.currentLatitude = Double(location!.coordinate.latitude);
            AppState.sharedInstance.currentLongitude = Double(location!.coordinate.longitude);
            strongSelf.acquireFirstCardsWithLocation(latitude: AppState.sharedInstance.currentLatitude!, longitude: AppState.sharedInstance.currentLongitude!)
            },
            failure: { [weak self] (error) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showRetryToGetLocationAlert()
            })
    }
    
    func acquireFirstCardsWithLocation(latitude: Double, longitude: Double) {
        self.acquireCardWithLatitude(latitude: latitude, longitude: longitude, maxBudget: self.currentBudget, numOfPeople: self.currentNumOfPeople, genre: self.currentGenre, reset: true,
            completion: { [weak self] (Bool) in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.acquireCardWithLatitude(latitude: latitude, longitude: longitude, maxBudget: strongSelf.currentBudget, numOfPeople: strongSelf.currentNumOfPeople, genre: strongSelf.currentGenre, reset: false, completion: nil)
        })
    }
    
    /**
    カードを取得
    */
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String? = nil, maxBudget: Budget, numOfPeople: NumOfPeople, genre: Genre, syncId: String? = nil, reset: Bool, completion: ((Bool)->())? = nil) {
        self.showIndicator()
        self.restaurantModel.fetch(latitude, longitude: longitude, like: like, maxBudget: maxBudget, numOfPeople: numOfPeople, genre: genre, syncId: syncId, reset: reset, handler: {[weak self] (result: PecomyResult<Restaurant, PecomyApiClientError>) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.hideIndicator()
            
            switch result {
            case .success(_):
                let cardView = strongSelf.createCard(frame: strongSelf.baseCardRect(), restaurant: strongSelf.restaurantModel.restaurant, syncID: strongSelf.restaurantModel.syncID)
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
            case .failure(let error):
                switch error.type {
                case .noResult:
                    if (reset) {
                        strongSelf.showOutOfRangeAlert()
                    } else {
                        strongSelf.acquireResults()
                    }
                case .serverError:
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
            self.contentView.sendSubview(toBack: card)
            UIView.animate(withDuration: 0.3,
                animations: {
                    card.alpha = 1
                }) { finished in
            }
            
        }
        self.stackedCards.removeAll()
    }
    
    // カードを作成
    func createCard(frame: CGRect, restaurant: Restaurant, syncID: String) -> CardView {
        let options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.onPan = { [weak self] state in
            guard let strongSelf = self else { return }
            if(strongSelf.numOfDisplayedCard() > 1){
                let frame = strongSelf.baseCardRect()
                let secondCard = strongSelf.contentView.subviews[0] as! CardView
                secondCard.frame = CGRect(x: frame.origin.x, y: frame.origin.y-((state?.thresholdRatio)! * 10.0), width: frame.width, height: frame.height)
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
            if type(of: cv) === CardView.self {
                offset += 6
            }
        }
        return offset
    }
    
    // 表示されてるカードの枚数を返す
    func numOfDisplayedCard() -> Int {
        var num = 0
        for cv in self.contentView.subviews {
            if type(of: cv) === CardView.self {
                num += 1
            }
        }
        return num
    }
    
    // カードのベースとなるCGRectを返す
    func baseCardRect() -> CGRect{
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: self.view.frame.width*0.8)
        rect.offsetBy(dx: (self.view.frame.width - rect.size.width)/2, dy: (self.view.frame.height - rect.size.height)/2 - 40)
        return rect
    }
    
    
    //MARK: - Result related methods
    
    /**
    結果（ここへ行け！リスト）を取得
    */
    
    func acquireResults() {
        self.resultModel.fetch(AppState.sharedInstance.currentLatitude!, longitude: AppState.sharedInstance.currentLongitude!,
            handler: {[weak self] (result: PecomyResult<ResultResponse, PecomyApiClientError>) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let res):
                    strongSelf.currentResults = res.results
                    strongSelf.displayResultViewWithShopList(restaurants: strongSelf.currentResults, message: res.displayMessage)
                case .failure(let error):
                    switch error.type{
                    case .noResult:
                        strongSelf.displayResultViewWithShopList(restaurants: [Restaurant](), message: "")
                    case .serverError:
                        strongSelf.showServerErrorAlert()
                    default:
                        strongSelf.showServerErrorAlert()
                    }
                }
            }
        )
    }
    
    func displayResultViewWithShopList(restaurants: [Restaurant], message: String) {
        let resultVC = ResultViewController(restaurants: restaurants, displayMessage: message)
        resultVC.delegate = self
        
        if (self.navigationController?.viewControllers.count == 1) {
            let navVC = UINavigationController(rootViewController: resultVC)
            resultVC.navigationItem.title = NSLocalizedString("ResultTitle", comment: "")
            self.isDisplayedResult = true
            self.present(navVC, animated: true, completion: nil)
        }
    }
    
    //MARK: - Button tapped Callbacks
    func likeButtonTapped() {
        self.swipeTopCard(toDirection: .right)
    }
    
    func dislikeButtonTapped() {
        self.swipeTopCard(toDirection: .left)
    }
    
    func reloadTapped() {
        self.onetimeFilterVC = OnetimeFilterViewController(budget: self.currentBudget, numOfPeople: self.currentNumOfPeople, genre: self.currentGenre)
        self.onetimeFilterVC!.delegate = self
        UIApplication.shared.keyWindow?.addSubview(self.onetimeFilterVC!.view)
    }
    
    func swipeTopCard(toDirection: MDCSwipeDirection) {
        if (self.numOfDisplayedCard() > 0) {
            let card = self.contentView.subviews[self.contentView.subviews.count-1] as! CardView
            if (!card.isFlicked) {
                card.isFlicked = true
                card.mdc_swipe(toDirection)
            }
        }
    }
    
    //MARK: - Alerts
    // アプリの対象範囲外アラート表示
    func showOutOfRangeAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("OutOfRangeAlertTitle", comment: ""),
            message: NSLocalizedString("OutOfRangeAlertMessage", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 現在地付近にこれ以上店舗が見つからない場合のアラート表示
    func showNotFoundRestaurantAroundHereAlert(completion: @escaping () -> Void, retry: @escaping () -> Void) {
        let alertController = UIAlertController(title:NSLocalizedString("RestaurantNotFoundAroundHereAlertTitle", comment: ""),
            message: NSLocalizedString("RestaurantNotFoundAroundHereAlertMessage", comment: ""),
            preferredStyle: .alert)
        let retryAction = UIAlertAction(title: NSLocalizedString("RestaurantNotFoundAroundHereAlertRetry", comment: ""), style: .default) { action in
            retry()
        }
        let okAction = UIAlertAction(title: NSLocalizedString("RestaurantNotFoundAroundHereAlertDisplayResult", comment: ""),
            style: .default) { action in
                completion()
        }
        alertController.addAction(retryAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 位置情報取得リトライのアラート表示
    func showRetryToGetLocationAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("LocationRetryAlertTitle", comment: ""),
            message: NSLocalizedString("LocationRetryAlertMessage", comment: ""),
            preferredStyle: .alert)
        let retryAction = UIAlertAction(title: NSLocalizedString("LocationRetryAlertRetryButtonTitle", comment: ""),
            style: .default, handler: { [weak self](action) in
                self!.acquireFirstCard()
            })
        alertController.addAction(retryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // サーバエラー時のアラート表示
    func showServerErrorAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("ServerErrorAlertTitle", comment: ""),
            message: NSLocalizedString("ServerErrorAlertMessage", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .default, handler: { [weak self](action) in
                self!.acquireFirstCard()
            })
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
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
}

//MARK: - OnetimeFilterViewControllerDelegate methods
extension MainViewController: OnetimeFilterViewControllerDelegate {
    func closeButtonTapped() {
        if let vc = self.onetimeFilterVC {
            vc.view.removeFromSuperview()
        }
        self.onetimeFilterVC = nil
    }
    
    func startSearch(_ budget: Budget, numOfPeople: NumOfPeople, genre: Genre) {
        // set filter
        self.currentBudget = budget
        self.currentNumOfPeople = numOfPeople
        self.currentGenre = genre
                
        if let vc = self.onetimeFilterVC {
            vc.view.removeFromSuperview()
        }
        self.onetimeFilterVC = nil
        
        // reset cards and request
        self.resetViews()
        
        if let lat = AppState.sharedInstance.currentLatitude, let lon = AppState.sharedInstance.currentLongitude {
            self.acquireFirstCardsWithLocation(latitude: lat, longitude: lon)
        } else {
            self.acquireFirstCard()
        }
    }
}


//MARK: - MDCSwipeToChooseDelegate Callbacks
extension MainViewController: MDCSwipeToChooseDelegate {
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(_ view: UIView!) {
    }
    
    // Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
    func view(_ view: UIView!, shouldBeChosenWith direction: MDCSwipeDirection) -> Bool {
        if (direction == .left || direction == .right) {
            return true
        } else {
            UIView.animate(withDuration: 0.16, animations: {() in
                view.transform = CGAffineTransform.identity
                view.center = view.superview!.center
            })
            return false
        }
    }
    
    
    // This is called then a user swipes the view fully left or right.
    func view(_ view: UIView!, wasChosenWith direction: MDCSwipeDirection) {
        let cardView = view as! CardView
        self.currentSwipeCount += 1
        cardView.isFlicked = true
        
        var answer = "dislike"
        if (direction == .right) {
            answer = "like"
            self.currentProgress += INCREMENT_LIKE
            self.progressBar.progress(withRatio: self.currentProgress)
        } else {
            self.currentProgress += INCREMENT_DISLIKE
            self.progressBar.progress(withRatio: self.currentProgress)
        }

        self.acquireCardWithLatitude(latitude: AppState.sharedInstance.currentLatitude!, longitude: AppState.sharedInstance.currentLongitude!, like: answer, maxBudget: self.currentBudget, numOfPeople: self.currentNumOfPeople, genre:self.currentGenre, syncId: cardView.syncID, reset: false)
        if (!self.canDisplayNextCard && self.contentView.subviews.count == 0) {
            self.acquireResults()
        }
    }
}


//MARK: - PecomyLocationManagerDelegate
extension MainViewController: PecomyLocationManagerDelegate {
    func showLocationEnableAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("LocationAlertTitle", comment: ""),
            message: NSLocalizedString("LocationAlertMessage", comment: ""),
            preferredStyle: .alert)
        let settingAction = UIAlertAction(title: NSLocalizedString("LocationAlertSettingButtonTitle", comment: ""),
            style: .default, handler: { (action) in
                let url = NSURL(string: UIApplicationOpenSettingsURLString)
                UIApplication.shared.openURL(url! as URL)
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
            style: .default, handler: nil)
        
        alertController.addAction(settingAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


//MARK: - ResultViewControllerDelegate
extension MainViewController: ResultViewControllerDelegate {
    func resultViewController(_ controller: ResultViewController, backButtonTappedWithReset reset: Bool) {
        self.dismiss(animated: true, completion: {[weak self]() in
            guard let strongSelf = self else {
                return
            }
            if reset {
                strongSelf.reset()
                strongSelf.displayOnetimeFilterView()
            } else {
                strongSelf.resetViews()
                strongSelf.canDisplayNextCard = true
                if !strongSelf.stackedCards.isEmpty {
                    strongSelf.displayStackedCard()
                } else {
                    strongSelf.showNotFoundRestaurantAroundHereAlert(completion: { () in
                        strongSelf.displayResultViewWithShopList(restaurants: strongSelf.currentResults, message: "")
                        }, retry: {() in
                            strongSelf.reset()
                            strongSelf.displayOnetimeFilterView()
                    })
                }
                }
            }
        )
    }
}


//MARK: - CardViewDelegate
extension MainViewController: CardViewDelegate {
    func blackListButtonTapped(_ card: CardView, shopID: Int) {
        let ac = UIAlertController(title: "", message: NSLocalizedString("BlackListButtonSendMessage", comment: ""), preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .default, handler: { (action) in
                let params = ["shop_id": shopID, "device_id": Utils.acquireDeviceID()] as [String : Any]
                Alamofire.request(Const.API_BLACKLIST_BASE, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { (dataResponse) in
                    if dataResponse.response?.statusCode == Const.STATUS_CODE_NOT_FOUND {
                        card.blackListButton.isEnabled = false
                    }
                }
        })
        let cancelAction = UIAlertAction(title: NSLocalizedString("Back", comment: ""),
            style: .default, handler: nil)
        ac.addAction(cancelAction)
        ac.addAction(okAction)
        self.present(ac, animated: true, completion: nil)
    }
}

//MARK: - TutorialDelegate
extension MainViewController: TutorialDelegate {
    func startTapped() {
        self.dismiss(animated: true) { _ in
            self.displayOnetimeFilterView()
            self.tutorialVC = nil
        }
    }
}
