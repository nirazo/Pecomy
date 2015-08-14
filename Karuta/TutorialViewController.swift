//
//  TutorialViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/10.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {

    var pageControl: UIPageControl!
    let imgTitleArr = ["tutorial_01", "tutorial_02", "tutorial_03", "tutorial_04", "tutorial_05", "tutorial_06"]
    
    override func viewDidLoad() {
        let width = self.view.frame.maxX
        let height = self.view.frame.maxY
        
        super.viewDidLoad()
        self.view.backgroundColor = Const.KARUTA_THEME_COLOR
        
        var scrollView = UIScrollView(frame: self.view.frame)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSizeMake(CGFloat(self.imgTitleArr.count)*width, 0)
        self.view.addSubview(scrollView)
        
        //各ページの作成
        for (var i=0; i<self.imgTitleArr.count; i++) {
            let img = UIImage(named:self.imgTitleArr[i])
            let iv = UIImageView(image:img)
            iv.contentMode = .ScaleAspectFit
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
        var closeButton = UIButton(frame: CGRectZero);
        closeButton.backgroundColor = UIColor.clearColor();
        closeButton.addTarget(self, action: "closeTutorial:", forControlEvents:.TouchUpInside);
        closeButton.setTitle(NSLocalizedString("CloseTutorial", comment: ""), forState: .Normal);
        closeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        closeButton.layer.masksToBounds = true;
        closeButton.titleLabel?.font = UIFont(name: Const.KARUTA_FONT_BOLD, size: 14)
        closeButton.sizeToFit()
        self.view.addSubview(closeButton);
        
        closeButton.snp_makeConstraints { (make) in
            make.right.equalTo(self.view).offset(-10)
            make.bottom.equalTo(self.view).offset(-10)
        }
    }
    
    func closeTutorial(sender: UIButton) {
        let viewController = MainViewController()
        var navVC = UINavigationController(rootViewController: viewController)
        navVC.navigationBar.barTintColor = Const.KARUTA_THEME_COLOR
        navVC.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        
        self.presentViewController(navVC, animated: true, completion: nil)
    }

    //MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        // スクロール数が1ページ分になったら時
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
