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
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: CGFloat(self.imgTitleArr.count)*width, height: 0)
        self.view.addSubview(self.scrollView)
        
        //各ページの作成
        for i in 0 ..< self.imgTitleArr.count {
            let img = UIImage(named:self.imgTitleArr[i])
            let iv = UIImageView(image:img)
            iv.contentMode = .scaleAspectFit
            iv.frame = CGRect(x: CGFloat(i) * width, y: 0, width: width, height: height)
            scrollView.addSubview(iv)
        }
        
        //閉じるボタン
        let closeButton = UIButton(frame: .zero)
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(TutorialViewController.startTapped(_:)), for:.touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(50)
            make.width.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.height.equalTo(48)
        }
    }
    
    func startTapped(_ sender: UIButton) {
        if(self.currentPage == self.imgTitleArr.count - 1) {
            UserDefaults.standard.set(true, forKey: Const.UD_KEY_HAS_LAUNCHED)
            UserDefaults.standard.synchronize()
            self.delegate?.startTapped()
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * CGFloat(self.currentPage+1), y: 0), animated: true)
        }
    }
    
    func changeRootViewController(_ viewController: UINavigationController) {
        
        let snapShot: UIView = UIApplication.shared.keyWindow!.snapshotView(afterScreenUpdates: true)!
        viewController.view.addSubview(snapShot)
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
        UIView.animate(withDuration: 0.3,
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
    }
}
