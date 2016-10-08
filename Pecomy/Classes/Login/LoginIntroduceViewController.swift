//
//  LoginIntroduceViewController.swift
//  Pecomy
//
//  Created by Kenzo on 10/2/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FeatureTextLabel: UIView {
    init(text: String) {
        super.init(frame: .zero)
        self.setupSubViews(text)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubViews(text: String) {
        let checkImage = UIImageView(image: R.image.login_check())
        self.addSubview(checkImage)
        checkImage.snp_makeConstraints { make in
            make.top.equalTo(self)
            make.height.equalTo(self)
            make.width.equalTo(self.snp_height)
            make.left.equalTo(self)
        }
        
        let label = UILabel()
        label.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 17)
        label.textColor = Const.PECOMY_DARK_FONT_COLOR
        label.numberOfLines = 0
        label.text = text
        self.addSubview(label)
        label.snp_makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(checkImage.snp_right).offset(10.5)
            make.height.equalTo(self)
        }
    }

}

class LoginIntroduceViewController: UIViewController {
    
    let loginModel = LoginModel()
    var completionHandlerWithLoggedIn: (() -> ())? // ログイン完了後、画面閉じた後の処理
    
    init(completionWithLoggedIn: (() ->())? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.completionHandlerWithLoggedIn = completionWithLoggedIn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .whiteColor()
        self.setupSubViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupSubViews() {
        let backgroundView = UIImageView(image: R.image.login_background())
        backgroundView.contentMode = .ScaleAspectFill
        backgroundView.clipsToBounds = true
        self.view.addSubview(backgroundView)
        backgroundView.snp_makeConstraints { make in
            make.top.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.height.equalTo(self.view).multipliedBy(0.53)
        }
        
        let closeButton = UIButton()
        let closeImage = R.image.close()?.tint(.whiteColor())
        closeButton.setImage(closeImage, forState: .Normal)
        closeButton.addTarget(self, action: #selector(LoginIntroduceViewController.closeDisplay), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        closeButton.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(35)
            make.right.equalTo(self.view).offset(-21)
            make.size.equalTo(21)
        }
        
        let logoImageView = UIImageView(image: R.image.login_logo())
        logoImageView.contentMode = .ScaleAspectFill
        self.view.addSubview(logoImageView)
        logoImageView.snp_makeConstraints { make in
            make.top.equalTo(self.view).offset(97)
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view).multipliedBy(0.73)
        }
        
        let subTitleLabel = UILabel()
        
        let attrText = NSMutableAttributedString(string: R.string.localizable.loginSubTitle())
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.8
        attrText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attrText.length))
        
        subTitleLabel.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 19)
        subTitleLabel.textColor = .whiteColor()
        subTitleLabel.numberOfLines = 0
        subTitleLabel.attributedText = attrText
        subTitleLabel.textAlignment = .Center
        self.view.addSubview(subTitleLabel)
        subTitleLabel.snp_makeConstraints { make in
            make.bottom.equalTo(backgroundView).offset(-66)
            make.centerX.equalTo(logoImageView)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }
        
        let loginDescribeLabel = UILabel()
        loginDescribeLabel.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 14)
        loginDescribeLabel.textColor = Const.PECOMY_DARK_FONT_COLOR
        loginDescribeLabel.numberOfLines = 0
        loginDescribeLabel.text = R.string.localizable.loginDescribeSentence()
        self.view.addSubview(loginDescribeLabel)
        loginDescribeLabel.snp_makeConstraints { make in
            make.top.equalTo(backgroundView.snp_bottom).offset(16)
            make.centerX.equalTo(self.view)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
        }
        
        let featureLabel1 = FeatureTextLabel(text: R.string.localizable.loginFeature1())
        self.view.addSubview(featureLabel1)
        featureLabel1.snp_makeConstraints { make in
            make.top.equalTo(loginDescribeLabel.snp_bottom).offset(30)
            make.left.equalTo(self.view).offset(35)
            make.height.equalTo(24)
        }
        
        let featureLabel2 = FeatureTextLabel(text: R.string.localizable.loginFeature2())
        self.view.addSubview(featureLabel2)
        featureLabel2.snp_makeConstraints { make in
            make.top.equalTo(featureLabel1.snp_bottom).offset(14)
            make.left.equalTo(featureLabel1)
            make.height.equalTo(24)
        }
        
        let featureLabel3 = FeatureTextLabel(text: R.string.localizable.loginFeature3())
        self.view.addSubview(featureLabel3)
        featureLabel3.snp_makeConstraints { make in
            make.top.equalTo(featureLabel2.snp_bottom).offset(14)
            make.left.equalTo(featureLabel1)
            make.height.equalTo(24)
        }
        
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        loginButton.snp_makeConstraints { make in
            make.centerX.equalTo(self.view)
            make.height.equalTo(50)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.bottom.greaterThanOrEqualTo(self.view).offset(-35)
        }
    }
    
    func closeDisplay() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LoginIntroduceViewController: FBSDKLoginButtonDelegate {
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
            self.loginModel.fetch(currentToken, handler: { [weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
                guard let strongSelf = self else { return }
                switch result {
                case .Success(_):
                    print("success!")
                    strongSelf.dismissViewControllerAnimated(true, completion: strongSelf.completionHandlerWithLoggedIn)
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
    }
}

