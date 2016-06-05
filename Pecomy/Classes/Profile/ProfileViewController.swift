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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        
        let loginButton = FBSDKLoginButton() // ボタンの作成
        loginButton.center = self.view.center // 位置をcenterに設定
        loginButton.delegate = self // 認証後の処理のためにdelegateを設定
        loginButton.readPermissions = ["public_profile", "email", "user_friends"] // 欲しいデータに合わせてpermissionを設定
        self.view.addSubview(loginButton) // viewにボタンを追加
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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