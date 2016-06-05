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

class ProfileViewController: UIViewController {
    
    static let title = "ユーザ"
    let loginModel = LoginModel()
    var delegate: ProfileViewControllerDelegate?
    let bgView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        
        self.setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSubViews() {
        //単色背景
        
//        self.bgView.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
//        self.view.addSubview(self.bgView)
//        self.bgView.snp_makeConstraints { make in
//            make.top.equalTo(Size.statusBarHeight() + Size.navBarHeight(navigationController!))
//            make.left.equalTo(self.view)
//            make.width.equalTo(self.view)
//            make.bottom.equalTo(self.view)
//        }
        
        let loginButton = FBSDKLoginButton() // ボタンの作成
        loginButton.center = self.view.center // 位置をcenterに設定
        loginButton.delegate = self // 認証後の処理のためにdelegateを設定
        loginButton.readPermissions = ["public_profile", "email", "user_friends"] // 欲しいデータに合わせてpermissionを設定
        self.view.addSubview(loginButton) // viewにボタンを追加
        self.view.backgroundColor = .clearColor()
    }
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