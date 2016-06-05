//
//  MainBaseViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/02/21.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit

class MainBaseViewController: UIViewController {
    
    var pagingBaseView = UIScrollView()
    var bgImageView = UIImageView(image: BackgroundImagePicker.pickImage())
    var bgImageMaskView = UIView()
    var imageShrinkPace: CGFloat = 0.0
    var imageHeight: CGFloat = 0.0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
        self.pagingBaseView.pagingEnabled = true
        self.pagingBaseView.bounces = false
        self.pagingBaseView.showsHorizontalScrollIndicator = false
        self.automaticallyAdjustsScrollViewInsets = false
        self.pagingBaseView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Const.APP_TITLE
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainBaseViewController.enterForeground(_:)), name:Const.WILL_ENTER_FOREGROUND_KEY, object: nil)
        
        //単色背景
        let bgView = UIView()
        bgView.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        self.view.addSubview(bgView)
        bgView.snp_makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view)
        }
        self.view.addSubview(self.bgImageMaskView)
        bgImageMaskView.snp_makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.width.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(2.56)
        }
        
        
        // 背景画像
        self.bgImageMaskView.backgroundColor = Const.PECOMY_BASIC_BACKGROUND_COLOR
        self.bgImageMaskView.addSubview(self.bgImageView)
        self.bgImageMaskView.clipsToBounds = true
        bgImageView.snp_makeConstraints { make in
            make.top.equalTo(self.bgImageMaskView)
            make.left.equalTo(self.bgImageMaskView)
            make.width.equalTo(self.bgImageMaskView)
            make.height.equalTo(self.bgImageMaskView)
        }
        
        self.pagingBaseView.frame = self.view.bounds
        
        self.view.addSubview(self.pagingBaseView)
        self.pagingBaseView.backgroundColor = UIColor.clearColor()
        
        let profileVC = ProfileViewController()
        profileVC.delegate = self
        self.addChildViewController(profileVC)
        profileVC.didMoveToParentViewController(self)
        
        let mainVC = MainViewController()
        self.addChildViewController(mainVC)
        mainVC.didMoveToParentViewController(self)
        
        
        self.pagingBaseView.contentSize = CGSize(width: self.pagingBaseView.frame.width * CGFloat(self.childViewControllers.count), height: self.pagingBaseView.frame.height)
        for (id, vc) in self.childViewControllers.enumerate() {
            vc.view.frame = CGRect(x: self.pagingBaseView.frame.width * CGFloat(id), y: 0.0, width: self.pagingBaseView.frame.width, height: self.pagingBaseView.frame.height)
            vc.didMoveToParentViewController(self)
            self.pagingBaseView.addSubview(vc.view)
        }
        self.pagingBaseView.contentOffset.x = self.view.bounds.width
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
    func enterForeground(notification: NSNotification){
        self.bgImageView.image = BackgroundImagePicker.pickImage()
    }

}

extension MainBaseViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        switch currentPage {
        case 0:
            self.title = ProfileViewController.title
        case 1:
            self.title = MainViewController.title
        case 2:
            self.title = "test"
        default:
            break
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView.contentOffset.x >= self.pagingBaseView.frame.width * CGFloat(1)) {
            return
        }
        if (scrollView.contentOffset.x == 0) {
            self.bgImageMaskView.frame.size.height = Size.navHeightIncludeStatusBar(self.navigationController!)
        } else if (scrollView.contentOffset.x == self.view.frame.width) {
            self.bgImageMaskView.frame.size.height = self.imageHeight
        } else {
            self.bgImageMaskView.frame.size.height = scrollView.contentOffset.x / self.imageShrinkPace + Size.navHeightIncludeStatusBar(self.navigationController!)
        }
    }
}

extension MainBaseViewController: ProfileViewControllerDelegate {
    func navTitleChanged(title: String) {
        self.title = title
    }
}
