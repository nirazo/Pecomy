//
//  SettingsViewController.swift
//  Pecomy
//
//  Created by Kenzo on 8/7/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

class SettingsViewController: UIViewController {
    let tableView = UITableView(frame: .zero, style: .grouped)
    final let cellIdentifier = "CellIdentifier"
    let fbLoginButton = FBSDKLoginButton()
    let loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { make in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.estimatedRowHeight = 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fbLoginButton.delegate = self
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
        cell.contentView.addSubview(self.fbLoginButton)
        self.fbLoginButton.snp.makeConstraints { make in
            make.left.equalTo(cell.contentView).offset(16)
            make.centerY.equalTo(cell)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("SettingsSocialSectionTitle", comment: "")
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(LoginModel.isLoggedIn()) {
            return ""
        } else {
            return NSLocalizedString("SettingsSocialSectionFooter", comment: "")
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    
}

extension SettingsViewController: FBSDKLoginButtonDelegate {
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil
        {
            print("error!")
        }
        else if result.isCancelled {
            print("canceled!")
        }
        else {
            let currentToken = FBSDKAccessToken.current().tokenString
            self.loginModel.fetch(currentToken!, handler: {[weak self] (result: PecomyResult<PecomyUser, PecomyApiClientError>) in
                guard let strongSelf = self else { return }
                switch result {
                case .success(_):
                    print("success!!")
                case .failure(let error):
                    let fb = FBSDKLoginManager()
                    fb.logOut()
                    KeychainManager.removePecomyUserToken()
                    print("error: \(error)")
                }
                strongSelf.tableView.reloadData()
                })
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        KeychainManager.removePecomyUserToken()
        self.tableView.reloadData()
    }
}
