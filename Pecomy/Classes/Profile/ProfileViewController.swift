//
//  ProfileViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/21.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class RecentHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Const.PECOMY_THEME_COLOR
        let label = UILabel()
        label.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 15)
        label.text = NSLocalizedString("RecentView", comment: "")
        label.textColor = .whiteColor()
        self.addSubview(label)
        label.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self).offset(14)
            make.right.equalTo(self)
            make.height.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfileViewController: UIViewController {
    
    let loginModel = LoginModel()
    let browsesModel = BrowsesModel()
    var browsesRestaurants = [Restaurant]()
    let favoritesModel = FavoritesModel()
    var favoritesRestaurants = [Restaurant]()
    let visitsModel = VisitsModel()
    var visitsRestaurants = [Restaurant]()
    
    let bgView = UIView()
    let favAndCheckinBgView = UIView()
    let userPhotoImageView = UIImageView()
    let numOfFavoriteLabel = UILabel()
    let numOfCheckinLabel = UILabel()
    let fbLoginButton = FBSDKLoginButton()
    let userNameLabel = UILabel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        self.browsesRestaurants = PecomyUser.sharedInstance.browses
        self.tableView.estimatedRowHeight = 100
        
        self.navigationController?.makeNavigationBarTranslucent()
        
        self.setupSubViews()
        
        if LoginModel.isLoggedIn() {
            let currentToken = FBSDKAccessToken.currentAccessToken().tokenString
            self.loginModel.fetch(currentToken, handler: {[weak self] (result: PecomyResult<PecomyUser, PecomyApiClientError>) in
                guard let strongSelf = self else { return }
                switch result {
                case .Success(_):
                    strongSelf.updateBrowsesList()
                    strongSelf.updateFavoritesList()
                    strongSelf.updateVisitsList()
                    strongSelf.updateUserName()
                    strongSelf.updateUserPicture()
                case .Failure(let error):
                    let fb = FBSDKLoginManager()
                    fb.logOut()
                    KeychainManager.removePecomyUserToken()
                    print("error occured and logout: \(error)")
                }
                })
        } else {
            // do nothing
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.makeNavigationBarTranslucent()
        self.updateBrowsesList()
        self.updateVisitsList()
        self.updateFavoritesList()
        self.updateUserPicture()
        self.updateUserName()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSubViews() {
        self.userPhotoImageView.clipsToBounds = true
        self.userPhotoImageView.layer.cornerRadius = self.userPhotoImageView.frame.size.width * 0.5
        self.userPhotoImageView.image = R.image.comment_human1()
        
        self.view.addSubview(self.userPhotoImageView)
        self.userPhotoImageView.snp_makeConstraints { make in
            make.top.equalTo(84)
            make.left.equalTo(19.5)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        self.fbLoginButton.delegate = self // 認証後の処理のためにdelegateを設定
        self.fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"] // 欲しいデータに合わせてpermissionを設定
        self.view.addSubview(self.fbLoginButton) // viewにボタンを追加
        self.fbLoginButton.snp_makeConstraints { make in
            make.top.equalTo(self.userPhotoImageView.snp_bottom).offset(12)
            make.left.equalTo(self.userPhotoImageView)
            make.height.equalTo(22)
        }
        
        self.userNameLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 17)
        self.view.addSubview(self.userNameLabel)
        self.userNameLabel.snp_makeConstraints { make in
            make.top.equalTo(self.userPhotoImageView.snp_bottom).offset(12)
            make.left.equalTo(self.userPhotoImageView)
            make.height.equalTo(22)
        }
        if(LoginModel.isLoggedIn()) {
            self.userNameLabel.text = PecomyUser.sharedInstance.userName
            self.fbLoginButton.hidden = true
        } else {
            self.userNameLabel.hidden = true
        }
        
        self.view.addSubview(self.favAndCheckinBgView)
        self.favAndCheckinBgView.snp_makeConstraints { make in
            make.top.equalTo(self.userPhotoImageView)
            make.left.equalTo(self.userPhotoImageView.snp_right)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.userPhotoImageView)
        }
        
        // セパレータ
        let userInfoSeparator = UIView()
        userInfoSeparator.backgroundColor = UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        self.favAndCheckinBgView.addSubview(userInfoSeparator)
        userInfoSeparator.snp_makeConstraints { make in
            make.top.equalTo(self.favAndCheckinBgView).offset(20)
            make.center.equalTo(self.favAndCheckinBgView)
            make.width.equalTo(1.5)
            make.bottom.equalTo(self.favAndCheckinBgView).offset(-20)
        }
        
        // お気に入りの数
        self.numOfFavoriteLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 20)
        self.numOfFavoriteLabel.textAlignment = .Center
        self.numOfFavoriteLabel.text = LoginModel.isLoggedIn() ? String(self.favoritesRestaurants.count) : "-"
        self.favAndCheckinBgView.addSubview(self.numOfFavoriteLabel)
        self.numOfFavoriteLabel.snp_makeConstraints { make in
            make.top.equalTo(userInfoSeparator).offset(8)
            make.centerX.equalTo(self.favAndCheckinBgView).dividedBy(2)
            make.centerY.equalTo(self.favAndCheckinBgView)
            make.height.equalTo(15.5)
        }
        
        // 「お気に入り」のテキスト
        let favoriteTextLabel = UILabel()
        favoriteTextLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        favoriteTextLabel.textAlignment = .Center
        favoriteTextLabel.text = NSLocalizedString("Favorite", comment: "")
        favoriteTextLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.favAndCheckinBgView.addSubview(favoriteTextLabel)
        favoriteTextLabel.snp_makeConstraints { make in
            make.top.equalTo(self.numOfFavoriteLabel.snp_bottom)
            make.centerX.equalTo(self.numOfFavoriteLabel)
            make.width.equalTo(58.5)
            make.height.equalTo(18.5)
        }
        
        // 「お気に入り」の透明ボタン
        let favoritesButton = UIButton()
        favoritesButton.addTarget(self, action: #selector(ProfileViewController.pushFavoritesList), forControlEvents: .TouchUpInside)
        favoritesButton.backgroundColor = .clearColor()
        self.favAndCheckinBgView.addSubview(favoritesButton)
        favoritesButton.snp_makeConstraints { make in
            make.center.equalTo(numOfFavoriteLabel)
            make.size.equalTo(numOfFavoriteLabel)
        }
        
        // チェックインの数
        self.numOfCheckinLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 20)
        self.numOfCheckinLabel.textAlignment = .Center
        self.numOfCheckinLabel.text = LoginModel.isLoggedIn() ? String(self.visitsRestaurants.count) : "-"
        self.favAndCheckinBgView.addSubview(self.numOfCheckinLabel)
        self.numOfCheckinLabel.snp_makeConstraints { make in
            make.top.equalTo(userInfoSeparator).offset(8)
            make.centerX.equalTo(self.favAndCheckinBgView).multipliedBy(1.5)
            make.centerY.equalTo(self.favAndCheckinBgView)
            make.height.equalTo(15.5)
        }
        
        // 「チェックイン」のテキスト
        let checkinTextLabel = UILabel()
        checkinTextLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        checkinTextLabel.textAlignment = .Center
        checkinTextLabel.text = NSLocalizedString("Checkin", comment: "")
        checkinTextLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.favAndCheckinBgView.addSubview(checkinTextLabel)
        checkinTextLabel.snp_makeConstraints { make in
            make.top.equalTo(self.numOfCheckinLabel.snp_bottom)
            make.centerX.equalTo(self.numOfCheckinLabel)
            make.width.equalTo(70.5)
            make.height.equalTo(18.5)
        }
        
        // 「チェックイン」の透明ボタン
        let visitsButton = UIButton()
        visitsButton.addTarget(self, action: #selector(ProfileViewController.pushVisitsList), forControlEvents: .TouchUpInside)
        visitsButton.backgroundColor = .clearColor()
        self.favAndCheckinBgView.addSubview(visitsButton)
        visitsButton.snp_makeConstraints { make in
            make.center.equalTo(numOfCheckinLabel)
            make.size.equalTo(numOfCheckinLabel)
        }
        
        self.view.backgroundColor = .clearColor()
        
        // 最近見たお店ヘッダー
        let recentHeaderView = RecentHeaderView()
        self.numOfCheckinLabel.addSubview(recentHeaderView)
        recentHeaderView.snp_makeConstraints { make in
            make.top.equalTo(self.userPhotoImageView.snp_bottom).offset(51)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(32)
        }
        
        // 最近見たお店のリスト
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(RestaurantListCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.top.equalTo(recentHeaderView.snp_bottom)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        self.tableView.reloadData()
    }
    
    func pushFavoritesList() {
        print("favorites!")
        let vc = FavoritesAndVisitsViewController(type: .Favorites, favoritesList: self.favoritesRestaurants, visitsList: self.visitsRestaurants)
        vc.navigationItem.title = "favorites"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pushVisitsList() {
        print("visits!")
        let vc = FavoritesAndVisitsViewController(type: .Visits, favoritesList: self.favoritesRestaurants, visitsList: self.visitsRestaurants)
        vc.navigationItem.title = "visits"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func updateBrowsesList() {
        if(LoginModel.isLoggedIn()) {
        self.browsesModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<[Restaurant], PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let result):
                strongSelf.browsesRestaurants = result
                strongSelf.tableView.reloadData()
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
        } else {
            self.clearBrowsesList()
        }
    }
    
    private func clearBrowsesList() {
        self.browsesRestaurants = []
        self.tableView.reloadData()
    }
    
    private func updateFavoritesList() {
        if(LoginModel.isLoggedIn()) {
        self.favoritesModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                strongSelf.favoritesRestaurants = user.favorites
                strongSelf.numOfFavoriteLabel.text = String(user.favorites.count)
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
        } else {
            self.clearFavoritesList()
        }
    }
    
    private func clearFavoritesList() {
        self.favoritesRestaurants = []
        self.numOfFavoriteLabel.text = "-"
    }
    
    private func updateVisitsList() {
        if(LoginModel.isLoggedIn()) {
        self.visitsModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                //print("visits: \(user.visits)")
                strongSelf.visitsRestaurants = user.visits
                strongSelf.numOfCheckinLabel.text = String(user.visits.count)
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
        } else {
            self.clearVisitsList()
        }
    }
    
    private func clearVisitsList() {
        self.visitsRestaurants = []
        self.numOfCheckinLabel.text = "-"
    }
    
    private func updateUserPicture() {
        if(LoginModel.isLoggedIn()) {
        guard let urlStr = KeychainManager.getPecomyUserPictureUrl(), picUrl = NSURL(string: urlStr) else { return }
        self.userPhotoImageView.sd_setImageWithURL(picUrl, completed: { [weak self] _ in
            guard let strongSelf = self else { return }
            strongSelf.userPhotoImageView.layer.cornerRadius = strongSelf.userPhotoImageView.frame.size.width * 0.5
        })
        } else {
            self.userPhotoImageView.image = R.image.comment_human1()
        }
    }
    
    private func updateUserName() {
        if (LoginModel.isLoggedIn()) {
            self.fbLoginButton.hidden = true
            self.userNameLabel.text = PecomyUser.sharedInstance.userName
            self.userNameLabel.hidden = false

        } else {
            self.userNameLabel.hidden = true
            self.fbLoginButton.hidden = false
        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.browsesRestaurants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! RestaurantListCell
        cell.configureCell(self.browsesRestaurants[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! RestaurantListCell
        let restaurant = cell.restaurant
        let detailVC = DetailViewController(restaurant: restaurant)
        detailVC.navigationItem.title = restaurant.shopName
        let backButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil
        {
            print("error!: \(error)")
        }
        else if result.isCancelled {
            print("canceled!")
        }
        else {
            let currentToken = FBSDKAccessToken.currentAccessToken().tokenString
            self.loginModel.fetch(currentToken, handler: {[weak self] (result: PecomyResult<PecomyUser, PecomyApiClientError>) in
                guard let strongSelf = self else { return }
                switch result {
                case .Success(_):
                    strongSelf.updateBrowsesList()
                    strongSelf.updateFavoritesList()
                    strongSelf.updateVisitsList()
                    strongSelf.updateUserPicture()
                    strongSelf.updateUserName()
                case .Failure(let error):
                    let fb = FBSDKLoginManager()
                    fb.logOut()
                    KeychainManager.removePecomyUserToken()
                    print("error: \(error)")
                }
                })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        KeychainManager.removePecomyUserToken()
        self.clearBrowsesList()
        self.clearVisitsList()
        self.clearFavoritesList()
        self.updateUserPicture()
        self.updateUserName()
    }
}
