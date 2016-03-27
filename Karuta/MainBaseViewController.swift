//
//  MainBaseViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/21.
//  Copyright © 2016年 Pecomy. All rights reserved.
//

import UIKit

class MainBaseViewController: UIViewController {
    
    var pagingBaseView = UIScrollView()
    var bgImageView = UIImageView(image: BackgroundImagePicker.pickImage())
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        self.pagingBaseView.pagingEnabled = true
        self.pagingBaseView.bounces = false
        self.pagingBaseView.showsHorizontalScrollIndicator = false
        self.automaticallyAdjustsScrollViewInsets = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainBaseViewController.enterForeground(_:)), name:Const.WILL_ENTER_FOREGROUND_KEY, object: nil)
        
        //単色背景
        let bgView = UIView()
        bgView.backgroundColor = Const.KARUTA_BASIC_BACKGROUND_COLOR
        self.view.addSubview(bgView)
        bgView.snp_makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        
        // 背景画像
        self.view.addSubview(self.bgImageView)
        bgImageView.snp_makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(2.56)
        }
        
        self.pagingBaseView.frame = self.view.bounds
        self.view.addSubview(self.pagingBaseView)
        self.pagingBaseView.backgroundColor = UIColor.clearColor()
        
        let mainViewController = MainViewController()
        let mainNavVC = self.createTransrateNavVC()
        mainNavVC.setViewControllers([mainViewController], animated: false)
        
        self.addChildViewController(mainNavVC)
//        let logViewController = RestaurantLogViewController()
//        let logNavVC = self.createTransrateNavVC()
//        logNavVC.setViewControllers([logViewController], animated: false)
//        self.addChildViewController(logNavVC)
        
        self.pagingBaseView.contentSize = CGSize(width: self.pagingBaseView.frame.width * CGFloat(self.childViewControllers.count), height: self.pagingBaseView.frame.height)
        for (id, vc) in self.childViewControllers.enumerate() {
            vc.view.frame = CGRect(x: self.pagingBaseView.frame.width * CGFloat(id), y: 0.0, width: self.pagingBaseView.frame.width, height: self.pagingBaseView.frame.height)
            vc.didMoveToParentViewController(self)
            self.pagingBaseView.addSubview(vc.view)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // navVCを透明化
    func createTransrateNavVC() -> UINavigationController {
        let navVC = UINavigationController()
        navVC.navigationBar.tintColor = UIColor.clearColor()
        navVC.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navVC.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Const.KARUTA_THEME_TEXT_COLOR]
        navVC.navigationBar.shadowImage = UIImage()
        return navVC
    }

    // MARK: - Observer
    func enterForeground(notification: NSNotification){
        self.bgImageView.image = BackgroundImagePicker.pickImage()
    }

}
