//
//  TutorialViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2016年 Pecomy. All rights reserved.
//

import UIKit

protocol TutorialDelegate {
    func startTapped()
}

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    var delegate: TutorialDelegate?
    var pageControl: UIPageControl!
    let imgTitleArr = ["tutorial_01", "tutorial_02", "tutorial_03", "tutorial_04", "tutorial_05"]
    
    override func viewDidLoad() {
        let width = self.view.frame.maxX
        let height = self.view.frame.maxY
        
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_THEME_COLOR
        
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(CGFloat(self.imgTitleArr.count)*width, 0)
        self.view.addSubview(scrollView)
        
        //各ページの作成
        for i in 0 ..< self.imgTitleArr.count {
            let img = UIImage(named:self.imgTitleArr[i])
            let iv = UIImageView(image:img)
            iv.contentMode = .ScaleAspectFill
            iv.frame = CGRectMake(CGFloat(i) * width, 0, width, height)
            scrollView.addSubview(iv)
        }
        
        //UIPageControllの作成
        pageControl = UIPageControl(frame: CGRectMake(0, height - 50, width, 50))
        pageControl.backgroundColor = UIColor.clearColor()
        pageControl.numberOfPages = self.imgTitleArr.count
        pageControl.currentPage = 0
        pageControl.userInteractionEnabled = false
        self.view.addSubview(pageControl)
        
        //閉じるボタン
        let closeButton = UIButton(frame: .zero)
        closeButton.backgroundColor = .clearColor()
        closeButton.addTarget(self, action: #selector(TutorialViewController.startTapped(_:)), forControlEvents:.TouchUpInside)
        closeButton.setTitle(NSLocalizedString("CloseTutorial", comment: ""), forState: .Normal)
        closeButton.setTitleColor(.blackColor(), forState: .Normal)
        closeButton.layer.masksToBounds = true
        closeButton.layer.cornerRadius = Const.CORNER_RADIUS
        closeButton.backgroundColor = .whiteColor()
        closeButton.titleLabel?.font = UIFont(name: Const.PECOMY_FONT_BOLD, size: 14)
        self.view.addSubview(closeButton)
        
        closeButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-10)
            make.width.equalTo(70)
            make.height.equalTo(35)
        }
    }
    
    func startTapped(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: Const.UD_KEY_HAS_LAUNCHED)
        NSUserDefaults.standardUserDefaults().synchronize()
        self.delegate?.startTapped()
    }
    
    func changeRootViewController(viewController: UINavigationController) {
        
        let snapShot: UIView = UIApplication.sharedApplication().keyWindow!.snapshotViewAfterScreenUpdates(true)
        viewController.view.addSubview(snapShot)
        UIApplication.sharedApplication().keyWindow?.rootViewController = viewController
        
        UIView.animateWithDuration(0.3,
            animations: { () in
                snapShot.layer.opacity = 0
                snapShot.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
        },
            completion: { (Bool) in
                snapShot.removeFromSuperview()
        })
    }

    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // スクロール数が1ページ分になった時
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}