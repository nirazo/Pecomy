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
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageViews = [
        UIImageView(image: R.image.tutorial_01()),
        UIImageView(image: R.image.tutorial_02()),
        UIImageView(image: R.image.tutorial_03())
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_THEME_COLOR

        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.isPagingEnabled = true
        self.scrollView.delegate = self
        self.view.addSubview(self.scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        //各ページの作成
        for i in 0 ..< imageViews.count {
            imageViews[i].contentMode = .scaleToFill
            contentView.addSubview(imageViews[i])
            imageViews[i].snp.makeConstraints { make in
                if i == 0 {
                    make.left.equalTo(scrollView)
                } else if i == imageViews.count - 1 {
                    make.left.equalTo(imageViews[i-1].snp.right)
                    make.right.equalTo(contentView)
                } else {
                    make.left.equalTo(imageViews[i-1].snp.right)
                }
                if #available(iOS 11, *) {
                    make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
                } else {
                    make.top.equalTo(view)
                    make.bottom.equalTo(view)
                }
                make.width.equalTo(view)
            }
        }
        
        //閉じるボタン
        let closeButton = UIButton(frame: .zero)
        closeButton.backgroundColor = .clear
        closeButton.addTarget(self, action: #selector(startTapped(_:)), for:.touchUpInside)
        self.view.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.width.equalTo(view)
            make.bottom.equalTo(imageViews[0])
            make.height.equalTo(48)
        }
    }
    
    @objc func startTapped(_ sender: UIButton) {
        if(self.currentPage == self.imageViews.count - 1) {
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
