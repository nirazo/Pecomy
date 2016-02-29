//
//  MainBaseViewController.swift
//  Karuta
//
//  Created by Kenzo on 2016/02/21.
//  Copyright © 2016年 Karuta. All rights reserved.
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
        self.navigationItem.title = Const.KARUTA_TITLE
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enterForeground:", name:Const.WILL_ENTER_FOREGROUND_KEY, object: nil)
        
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
//        
//        let profViewController = ProfileViewController()
//        let profNavVC = UINavigationController(rootViewController: profViewController)
//        self.addChildViewController(profNavVC)
        let mainViewController = MainViewController()
        let mainNavVC = UINavigationController(rootViewController: mainViewController)
        self.addChildViewController(mainNavVC)
        let logViewController = RestaurantLogViewController()
        let logNavVC = UINavigationController(rootViewController: logViewController)
        self.addChildViewController(logNavVC)
        
        self.pagingBaseView.contentSize = CGSize(width: self.pagingBaseView.frame.width * CGFloat(self.childViewControllers.count), height: self.pagingBaseView.frame.height)
        for (id, vc) in self.childViewControllers.enumerate() {
            vc.view.frame = CGRect(x: self.pagingBaseView.frame.width * CGFloat(id), y: 0.0, width: self.pagingBaseView.frame.width, height: self.pagingBaseView.frame.height)
            vc.didMoveToParentViewController(self)
            self.pagingBaseView.addSubview(vc.view)
        }
        //self.pagingBaseView.contentOffset = CGPoint(x: Const.WindowSize.width, y: 0.0)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    // MARK: - Observer
    func enterForeground(notification: NSNotification){
        self.bgImageView.image = BackgroundImagePicker.pickImage()
    }

}
