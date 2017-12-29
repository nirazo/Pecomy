//
//  MainBaseViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/21.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MainBaseViewController: UIViewController {
    
    var pagingBaseView = UIScrollView()
    var bgImageView = UIImageView(image: BackgroundImagePicker.pickImage())
    var bgImageMaskView = UIView()
    var imageShrinkPace: CGFloat = 0.0
    var imageHeight: CGFloat = 0.0
    
    // 管理するViewController
    let profileVC = ProfileViewController()
    let mainVC = MainViewController()
    
    let userButton = UIBarButtonItem()
    let settingsButton = UIBarButtonItem()
    let cardButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        self.pagingBaseView.isPagingEnabled = true
        self.pagingBaseView.bounces = false
        self.pagingBaseView.showsHorizontalScrollIndicator = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.pagingBaseView.delegate = self
        
        self.userButton.target = self
        self.userButton.image = R.image.icon_user()?.withRenderingMode(.alwaysOriginal)
        self.userButton.action = #selector(userButtonDidTap(_:))
        self.settingsButton.target = self
        self.settingsButton.image = R.image.icon_settings()?.withRenderingMode(.alwaysOriginal)
        self.settingsButton.action = #selector(settingsButtonDidTap(_:))
        self.cardButton.target = self
        self.cardButton.image = R.image.icon_card()?.withRenderingMode(.alwaysOriginal)
        self.cardButton.action = #selector(cardButtonDidTap(_:))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Const.APP_TITLE
        NotificationCenter.default.addObserver(self, selector: #selector(enterForeground(_:)), name:NSNotification.Name(rawValue: Const.WILL_ENTER_FOREGROUND_KEY), object: nil)
        
        //単色背景
        let bgView = UIView()
        bgView.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        self.view.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        self.view.addSubview(self.bgImageMaskView)
        bgImageMaskView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(2.56)
        }
        
        
        // 背景画像
        self.bgImageMaskView.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        self.bgImageMaskView.addSubview(self.bgImageView)
        self.bgImageMaskView.clipsToBounds = true
        bgImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(2.56)
        }
        
        self.pagingBaseView.frame = self.view.bounds
        
        self.view.addSubview(self.pagingBaseView)
        self.pagingBaseView.backgroundColor = UIColor.clear
        
        self.addChildViewController(self.profileVC)
        profileVC.didMove(toParentViewController: self)
        
        self.addChildViewController(self.mainVC)
        mainVC.didMove(toParentViewController: self)
        
        
        self.pagingBaseView.contentSize = CGSize(width: self.pagingBaseView.frame.width * CGFloat(self.childViewControllers.count), height: self.pagingBaseView.frame.height)
        for (id, vc) in self.childViewControllers.enumerated() {
            vc.view.frame = CGRect(x: self.pagingBaseView.frame.width * CGFloat(id), y: 0.0, width: self.pagingBaseView.frame.width, height: self.pagingBaseView.frame.height)
            vc.didMove(toParentViewController: self)
            self.pagingBaseView.addSubview(vc.view)
        }
        self.pagingBaseView.contentOffset.x = self.view.bounds.width
        self.navigationItem.leftBarButtonItem = self.userButton
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    override func viewDidLayoutSubviews() {
        if (self.bgImageMaskView.frame.height != 0.0 && self.imageHeight == 0.0) {
            self.imageHeight = self.bgImageMaskView.frame.size.height
            self.imageShrinkPace = self.view.frame.width / (self.imageHeight - Size.navHeightIncludeStatusBar(self.navigationController!))
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Observer
    @objc func enterForeground(_ notification: Notification){
        self.bgImageView.image = BackgroundImagePicker.pickImage()
    }
    
    // MARK: - Button Action
    @objc func cardButtonDidTap(_ sender: UIBarButtonItem) {
        print("card tapped")
        self.pagingBaseView.setContentOffset(CGPoint(x: self.pagingBaseView.frame.width, y: 0), animated: true)
    }
    
    @objc func userButtonDidTap(_ sender: UIBarButtonItem) {
        print("user tapped")
        self.pagingBaseView.setContentOffset(.zero, animated: true)
    }
    
    @objc func settingsButtonDidTap(_ sender: UIBarButtonItem) {
        let settingsVC = SettingsViewController()
        let navVC = UINavigationController(rootViewController: settingsVC)
        settingsVC.navigationItem.title = NSLocalizedString("SettingsTitle", comment: "")
        self.present(navVC, animated: true, completion: nil)
    }

}

extension MainBaseViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPageChanged(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.currentPageChanged(scrollView)
    }
    
    fileprivate func currentPageChanged(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        switch currentPage {
        case 0:
            self.title = NSLocalizedString("ProfileTitle", comment: "")
            self.navigationItem.leftBarButtonItem = self.settingsButton
            self.navigationItem.rightBarButtonItem = self.cardButton
        case 1:
            self.title = MainViewController.title
            self.navigationItem.leftBarButtonItem = self.userButton
            self.navigationItem.rightBarButtonItem = nil
        case 2:
            self.title = "test"
        default:
            break
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.x >= self.pagingBaseView.frame.width * CGFloat(1)) {
            return
        }
        if (scrollView.contentOffset.x == 0) {
            self.bgImageMaskView.snp.remakeConstraints { make in
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.width.equalTo(self.view)
                make.height.equalTo(Size.navHeightIncludeStatusBar(self.navigationController!))
            }
        } else if (scrollView.contentOffset.x == self.view.frame.width) {
            self.bgImageMaskView.snp.remakeConstraints { make in
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.width.equalTo(self.view)
                make.height.equalTo(self.imageHeight)
            }
        } else {
            self.bgImageMaskView.snp.remakeConstraints { make in
                make.top.equalTo(self.view)
                make.left.equalTo(self.view)
                make.width.equalTo(self.view)
                make.height.equalTo(scrollView.contentOffset.x / self.imageShrinkPace + Size.navHeightIncludeStatusBar(self.navigationController!))
            }
        }
        self.bgImageMaskView.updateConstraintsIfNeeded()
        self.bgImageMaskView.layoutIfNeeded()
    }
}
