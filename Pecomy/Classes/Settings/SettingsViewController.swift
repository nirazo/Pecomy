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
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        #if RELEASE
            return 1
        #else
            return 2
        #endif
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        #if RELEASE
            return 1
        #else
            switch section {
            case 0:
                return 1
            case 1:
                return 1
            default:
                return 1
            }
        #endif
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            cell.contentView.addSubview(self.fbLoginButton)
            self.fbLoginButton.snp.makeConstraints { make in
                make.left.equalTo(cell.contentView).offset(16)
                make.centerY.equalTo(cell)
            }
            return cell
        case 1: // デバッグモード
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            cell.textLabel?.text = R.string.localizable.settingsDebug()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("SettingsSocialSectionTitle", comment: "")
        case 1:
            return R.string.localizable.settingsDebug()
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 0:
            if(LoginModel.isLoggedIn()) {
            return ""
        } else {
            return NSLocalizedString("SettingsSocialSectionFooter", comment: "")
        }
        case 1:
            return ""
        default:
            return ""
        }
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            let debugSettingsVC = DebugSettingsViewController()
            self.navigationController?.pushViewController(debugSettingsVC, animated: true)
        }
    }
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
