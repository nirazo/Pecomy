//
//  ProfileViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/21.
//  Copyright © 2016年 Pecomy. All rights reserved.
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
        //loginButton.readPermissions = ["public_profile"] // 欲しいデータに合わせてpermissionを設定
        self.view.addSubview(loginButton) // viewにボタンを追加
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // TODO: - FBのログインは別途FBLoginModelとかで切り出した方が良いかも
    func fetchUserName(completion: (String?) -> ()) {
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name"])
        var userName: String?
        graphRequest.startWithCompletionHandler { (connection, result, error) in
            if error != nil {
                print("error!!")
            } else {
                userName = result.valueForKey("name") as? String
            }
            completion(userName)
        }
    }
}

extension ProfileViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("ログイン開始")
        if ((error) != nil)
        {
            print("error!")
        }
        else if result.isCancelled {
            print("canceled!")
        }
        else {
            self.fetchUserName { userName in
                let currentToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.loginModel.fetch(currentToken, handler: {[weak self] (result: PecomyResult<String, PecomyApiClientError>) in
                    guard let strongSelf = self, userName = userName else { return }
                    switch result {
                    case .Success(_):
                        strongSelf.delegate?.navTitleChanged(userName)
                    case .Failure(let error):
                        let fb = FBSDKLoginManager()
                        fb.logOut()
                        print("error: \(error)")
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        KeychainManager.removeValue(Const.UserTokenKeychainKey)
    }
}