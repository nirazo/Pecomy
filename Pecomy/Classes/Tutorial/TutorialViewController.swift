//
//  TutorialViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit

protocol TutorialDelegate {
    func startTapped()
}

class TutorialViewController: UIViewController {

    var delegate: TutorialDelegate?
    var currentPage = 0
    let imgTitleArr = ["tutorial_01", "tutorial_02", "tutorial_03"]
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        let width = self.view.frame.maxX
        let height = self.view.frame.maxY
        
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_THEME_COLOR
        
        self.scrollView.frame = self.view.bounds
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(CGFloat(self.imgTitleArr.count)*width, 0)
        self.view.addSubview(self.scrollView)
        
        //各ページの作成
        for i in 0 ..< self.imgTitleArr.count {
            let img = UIImage(named:self.imgTitleArr[i])
            let iv = UIImageView(image:img)
            iv.contentMode = .ScaleAspectFill
            iv.frame = CGRectMake(CGFloat(i) * width, 0, width, height)
            scrollView.addSubview(iv)
        }
        
        //閉じるボタン
        let closeButton = UIButton(frame: .zero)
        closeButton.backgroundColor = .clearColor()
        closeButton.addTarget(self, action: #selector(TutorialViewController.startTapped(_:)), forControlEvents:.TouchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp_makeConstraints { (make) in
            make.left.equalTo(self.view).offset(50)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(48)
        }
    }
    
    func startTapped(sender: UIButton) {
        if(self.currentPage == self.imgTitleArr.count - 1) {
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: Const.UD_KEY_HAS_LAUNCHED)
            NSUserDefaults.standardUserDefaults().synchronize()
            self.delegate?.startTapped()
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * CGFloat(self.currentPage+1), y: 0), animated: true)
        }
    }
    
    func changeRootViewController(viewController: UINavigationController) {
        
        let snapShot: UIView = UIApplication.sharedApplication().keyWindow!.snapshotViewAfterScreenUpdates(true)!
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        self.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }
}
