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

protocol ProfileViewControllerDelegate {
    func navTitleChanged(title: String)
}

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
    
    static let title = "個人設定"
    let loginModel = LoginModel()
    let browsesModel = BrowsesModel()
    var browsesRestaurants = [Restaurant]()
    let favoritesModel = FavoritesModel()
    var favoritesRestaurants = [Restaurant]()
    let visitsModel = VisitsModel()
    var visitsRestaurants = [Restaurant]()
    
    var delegate: ProfileViewControllerDelegate?
    let bgView = UIView()
    let userPhotoImageView = UIImageView()
    let numOfFavoriteLabel = UILabel()
    let numOfCheckinLabel = UILabel()
    let fbLoginButton = FBSDKLoginButton()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        
        self.setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSubViews() {
        
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
        
        // セパレータ
        let userInfoSeparator = UIView()
        userInfoSeparator.backgroundColor = UIColor(red: 179.0/255.0, green: 179.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        self.view.addSubview(userInfoSeparator)
        userInfoSeparator.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(104)
            make.left.equalTo(self.view).offset(249)
            make.width.equalTo(1.5)
            make.height.equalTo(60)
        }
        
        // お気に入りの数
        self.numOfFavoriteLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 20)
        self.numOfFavoriteLabel.textAlignment = .Center
        self.numOfFavoriteLabel.text = self.loginModel.isLoggedIn() ? String(PecomyUser.sharedInstance.favorites.count):"-"
        self.view.addSubview(self.numOfFavoriteLabel)
        self.numOfFavoriteLabel.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(112.5)
            make.left.equalTo(self.userPhotoImageView.snp_right).offset(5.5)
            make.right.equalTo(userInfoSeparator.snp_left).offset(-5)
            make.height.equalTo(30.5)
        }
        
        // 「お気に入り」のテキスト
        let favoriteTextLabel = UILabel()
        favoriteTextLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        favoriteTextLabel.textAlignment = .Center
        favoriteTextLabel.text = NSLocalizedString("Favorite", comment: "")
        favoriteTextLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.view.addSubview(favoriteTextLabel)
        favoriteTextLabel.snp_makeConstraints { make in
            make.top.equalTo(self.numOfFavoriteLabel.snp_bottom)
            make.centerX.equalTo(self.numOfFavoriteLabel)
            make.width.equalTo(58.5)
            make.height.equalTo(18.5)
        }
        
        // チェックインの数
        self.numOfCheckinLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 20)
        self.numOfCheckinLabel.textAlignment = .Center
        self.numOfCheckinLabel.text = self.loginModel.isLoggedIn() ? String(PecomyUser.sharedInstance.visits.count) : "-"
        self.view.addSubview(self.numOfCheckinLabel)
        self.numOfCheckinLabel.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(112.5)
            make.left.equalTo(userInfoSeparator.snp_right).offset(5)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalTo(30.5)
        }
        
        // 「チェックイン」のテキスト
        let checkinTextLabel = UILabel()
        checkinTextLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 12)
        checkinTextLabel.textAlignment = .Center
        checkinTextLabel.text = NSLocalizedString("Checkin", comment: "")
        checkinTextLabel.textColor = UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
        self.view.addSubview(checkinTextLabel)
        checkinTextLabel.snp_makeConstraints { make in
            make.top.equalTo(self.numOfCheckinLabel.snp_bottom)
            make.centerX.equalTo(self.numOfCheckinLabel)
            make.width.equalTo(70.5)
            make.height.equalTo(18.5)
        }
        
        self.view.backgroundColor = .clearColor()
        
        // 最近見たお店ヘッダー
        let recentHeaderView = RecentHeaderView()
        self.view.addSubview(recentHeaderView)
        recentHeaderView.snp_makeConstraints { make in
            make.top.equalTo(self.fbLoginButton.snp_bottom).offset(12)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(32)
        }
        
        // 最近見たお店のリスト
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.top.equalTo(recentHeaderView.snp_bottom)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
    }
    
    private func updateBrowsesList() {
        self.browsesModel.fetch(111.11, longitude: 111.11, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                strongSelf.browsesRestaurants = user.browses
                strongSelf.tableView.reloadData()
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
    }
    
    private func updateFavoritesList() {
        self.favoritesModel.fetch(111.11, longitude: 111.11, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                strongSelf.numOfFavoriteLabel.text = String(user.favorites.count)
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
    }
    
    private func updateVisitsList() {
        self.visitsModel.fetch(111.11, longitude: 111.11, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                strongSelf.numOfCheckinLabel.text = String(user.visits.count)
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
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
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)
        cell.textLabel?.text = self.browsesRestaurants[indexPath.row].shopName
        return cell
    }
    
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if error != nil
        {
            print("error!")
        }
        else if result.isCancelled {
            print("canceled!")
        }
        else {
            let currentToken = FBSDKAccessToken.currentAccessToken().tokenString
            self.loginModel.fetch(currentToken, handler: {[weak self] (result: PecomyResult<PecomyUser, PecomyApiClientError>) in
                guard let strongSelf = self else { return }
                switch result {
                case .Success(let user):
                    strongSelf.delegate?.navTitleChanged(user.userName)
                    strongSelf.updateBrowsesList()
                    strongSelf.updateFavoritesList()
                    strongSelf.updateVisitsList()
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
    }
}