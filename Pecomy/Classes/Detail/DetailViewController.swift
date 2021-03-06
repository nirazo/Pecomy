//
//  DetailViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    let ANALYTICS_TRACKING_CODE = AnaylyticsTrackingCode.RestaurantDetailViewController.rawValue
    
    var restaurant = Restaurant()
    var detailView: RestaurantDetailView?
    
    var picConfig: RestaurantDetailViewPictureCollectionViewConfig?
    var richTagConfig: RestaurantDetailViewRichTagCollectionViewConfig?
    
    let browsesModel = BrowsesModel()
    let visitsModel = VisitsModel()
    let favoriteModel = FavoritesModel()
    
    let loadingView = LoadingView()
    // ポップアップ出す時の半透明ビュー
    let bgCoverView = UIView(frame: UIScreen.main.bounds)
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bgCoverView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        let tr = UITapGestureRecognizer(target: self, action: #selector(bgCoverViewTapped))
        self.bgCoverView.addGestureRecognizer(tr)
        
        self.view.backgroundColor = Const.PECOMY_RESULT_BACK_COLOR
        self.edgesForExtendedLayout = UIRectEdge()
        
        self.navigationController?.makeNavigationBarDefault()
        
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
            let backButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: nil, action: nil)
            strongSelf.navigationItem.backBarButtonItem = backButtonItem
            strongSelf.navigationController?.pushViewController(mapVC, animated: true)
        }
        
        self.picConfig?.delegate = self
        self.detailView?.setup(self.restaurant)
        self.detailView?.picturesView.delegate = self.picConfig
        self.detailView?.picturesView.dataSource = self.picConfig
        
        self.detailView?.picturesView.isScrollEnabled = true
        self.detailView?.picturesView.isUserInteractionEnabled = true
        self.detailView?.richTagsView.delegate = self.richTagConfig
        self.detailView?.richTagsView.dataSource = self.richTagConfig
        self.view.addSubview(detailView!)
        self.detailView?.snp.makeConstraints { (make) in
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        self.detailView?.setupView()
        self.detailView?.picturesView.reloadData()
        self.detailView?.picturesView.setNeedsLayout()
        
        self.detailView?.telButton.addTarget(self, action: #selector(telButtonTapped(_:)), for: .touchUpInside)
        
        self.detailView?.checkinBottomBar.checkedin = self.restaurant.visits > 0
        self.detailView?.checkinBottomBar.favorite = self.restaurant.favorite
        
        // チェックインタップ時のアクション登録
        self.detailView?.checkinBottomBar.checkinTapped =  {  [weak self]() in
            guard let strongSelf = self else { return }
            if (!LoginModel.isLoggedIn()) {
                let vc = LoginIntroduceViewController { () in
                    strongSelf.registerCheckin()
                }
                strongSelf.present(vc, animated: true, completion: nil)
            } else {
                strongSelf.registerCheckin()
            }
        }
        
        // お気に入りタップ時のアクション登録
        self.detailView?.checkinBottomBar.favoriteTapped =  { [weak self]() in
            guard let strongSelf = self else { return }
            if (!LoginModel.isLoggedIn()) {
                let vc = LoginIntroduceViewController { () in
                    strongSelf.registerBookmark()
                }
                strongSelf.present(vc, animated: true, completion: nil)
            } else {
                strongSelf.registerBookmark()
            }
        }
        
        self.detailView?.richTagsView.reloadData()
        self.detailView?.richTagsView.setNeedsLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        
        let tracker = GAI.sharedInstance().defaultTracker
        tracker?.set(kGAIScreenName, value: self.ANALYTICS_TRACKING_CODE)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker?.send(builder?.build() as [NSObject : AnyObject]!)
        
        // browses登録リクエスト
        self.browsesModel.register(self.restaurant.shopID, handler: {[weak self](result: PecomyResult<PecomyApiResponse, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(_):
                print("history registered!!: \(strongSelf.restaurant.shopID)")
            case .failure(let error):
                print("history register error: \(error.code), \(String(describing: error.response))")
            }
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func telButtonTapped(_ sender: AnyObject) {
        let telURL = URL(string: "tel://\(self.restaurant.tel)")
        if let telURL = telURL {
            let ac = UIAlertController(title: "", message: NSLocalizedString("TelAlertMessage", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("TelAlertTelButton", comment: ""),
                style: .default, handler: { (action) in
                    UIApplication.shared.openURL(telURL)
            })
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""),
                style: .default, handler: nil)
            ac.addAction(cancelAction)
            ac.addAction(okAction)
            self.present(ac, animated: true, completion: nil)
        }
    }
    
    //MARK: - Alert
    // 登録時のアラート表示
    func showRegisterErrorAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("RegisterFailedAlertTitle", comment: ""),
                                                message: NSLocalizedString("RegisterFailedAlertMessage", comment: ""),
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func startLoading() {
        self.view.addSubview(self.loadingView)
        self.loadingView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
    }
    
    func stopLoading() {
        self.loadingView.removeFromSuperview()
    }
    
    func displayRegisterPopup(_ type: RegisterType) {
        UIApplication.shared.keyWindow?.addSubview(self.bgCoverView)
        
        let registerPopup = RegisterPopupView(frame: .zero, shopName: self.restaurant.shopName, type: type)
        self.bgCoverView.addSubview(registerPopup)
        registerPopup.snp.makeConstraints { make in
            make.center.equalTo(self.bgCoverView)
            make.width.equalTo(260)
            make.height.greaterThanOrEqualTo(180)
        }
    }
    
    @objc func bgCoverViewTapped() {
        self.bgCoverView.removeFromSuperview()
    }
    
    func registerCheckin() {
        self.startLoading()
        print("checkin tapped!")
        self.visitsModel.register(self.restaurant.shopID, reviewScore: 1, handler: {[weak self](result: PecomyResult<PecomyApiResponse, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            strongSelf.stopLoading()
            switch result {
            case .success(_):
                print("checkin registered!!: \(strongSelf.restaurant.shopID)")
                strongSelf.displayRegisterPopup(RegisterType.checkin)
                strongSelf.detailView?.checkinBottomBar.checkedin = true
            case .failure(let error):
                print("checkin register error: \(strongSelf.restaurant.shopID), \(error.code), \(String(describing: error.response))")
                strongSelf.showRegisterErrorAlert()
            }
            })
    }
    
    func registerBookmark() {
        self.startLoading()
        print("favorite tapped!")
        self.favoriteModel.register(self.restaurant.shopID, handler: {[weak self](result: PecomyResult<PecomyApiResponse, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            strongSelf.stopLoading()
            switch result {
            case .success(_):
                print("favorite registered!!: \(strongSelf.restaurant.shopID)")
                strongSelf.displayRegisterPopup(RegisterType.favorite)
                strongSelf.detailView?.checkinBottomBar.favorite = true
            case .failure(let error):
                print("favorite register error: \(error.code), \(String(describing: error.response))")
                strongSelf.showRegisterErrorAlert()
            }
        })
    }

}

extension DetailViewController: DetailPictureCollectionViewConfigDelegate {
    func pictureTapped(_ imageView: UIImageView, index: Int, urlStrings: [String]) {
        let photoVC = PhotoViewerViewController(imageUrlStrings: urlStrings, index: index)
        photoVC.modalPresentationStyle = .overCurrentContext
        self.present(photoVC, animated: false, completion: nil)
        UIApplication.shared.keyWindow?.addSubview(photoVC.view)
        photoVC.display(self.view, imageView: imageView)
    }
}
