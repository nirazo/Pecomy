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
    let tableView = UITableView(frame: .zero, style: .Grouped)
    final let cellIdentifier = "CellIdentifier"
    let fbLoginButton = FBSDKLoginButton()
    let loginModel = LoginModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.snp_makeConstraints { make in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
        self.tableView.estimatedRowHeight = 50
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.fbLoginButton.delegate = self
        
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier, forIndexPath: indexPath)
        cell.contentView.addSubview(self.fbLoginButton)
        self.fbLoginButton.snp_makeConstraints { make in
            make.left.equalTo(cell.contentView).offset(16)
            make.centerY.equalTo(cell)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("SettingsSocialSectionTitle", comment: "")
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
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
                case .Success(_):
                    print("success!!")
                case .Failure(let error):
                    let fb = FBSDKLoginManager()
                    fb.logOut()
                    KeychainManager.removePecomyUserToken()
                    print("error: \(error)")
                }
                strongSelf.tableView.reloadData()
                })
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        KeychainManager.removePecomyUserToken()
        self.tableView.reloadData()
    }
}
