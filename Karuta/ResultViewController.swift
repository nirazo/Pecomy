//
//  ResultViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

protocol ResultViewControllerDelegate {
    func resultViewController(controller: ResultViewController, backButtonTappedWithReset reset: Bool)
}

class ResultViewController: UIViewController, ResultCardBaseDelegate {
    
    let ANALYTICS_TRACKING_CODE = AnaylyticsTrackingCode.ResultViewController.rawValue
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    // 結果同士のマージン
    let RESULT_MARGIN: CGFloat = 16

    let restaurants: [Restaurant]
    
    var topResultCard: TopResultCard?
    
    var otherResultsCard: OtherResultsCard?
    
    var otherResultsBaseView = UIView()
    
    let firstRankHeader = ResultHeaderView(frame: CGRectZero, section: 0)
    
    let secondRankHeader = ResultHeaderView(frame: CGRectZero, section: 1)
    
    var delegate: ResultViewControllerDelegate?
    
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.KARUTA_RESULT_BACK_COLOR
        self.edgesForExtendedLayout = .None
        
        let resetButoon = UIBarButtonItem(title: NSLocalizedString("Reset", comment: ""), style: .Plain, target: self, action: "resetTapped")
        self.navigationItem.rightBarButtonItem = resetButoon
        let continueButton = UIBarButtonItem(title: NSLocalizedString("Continue", comment: ""), style: .Plain, target: self, action: "continueTapped")
        self.navigationItem.leftBarButtonItem = continueButton
        
        switch self.restaurants.count {
        case 0:
            self.layoutNoResult()
            self.showNoResultAlert()
        default:
            self.setupLayout()
            break
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Google Analytics
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: self.ANALYTICS_TRACKING_CODE)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = self.contentView.frame.size
    }
    
    // 結果が存在する場合のレイアウト
    private func setupLayout() {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 32, 0)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        self.scrollView.snp_makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp_makeConstraints { (make) in
            make.width.equalTo(self.scrollView)
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(self.scrollView)
        }
        
        // 1位
        self.contentView.addSubview(self.firstRankHeader)
        self.firstRankHeader.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.height.equalTo(32)
            make.width.equalTo(self.contentView).offset(-32)
            make.right.equalTo(self.contentView).offset(-16)
            make.top.equalTo(self.contentView).offset(16)
        }
        
        self.topResultCard = TopResultCard.instance()
        self.topResultCard?.setup(self.restaurants[0])
        self.contentView.addSubview(topResultCard!)
        self.topResultCard?.snp_makeConstraints { (make) in
            make.width.equalTo(self.contentView).offset(-RESULT_MARGIN*2)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.firstRankHeader.snp_bottom).offset(8)
            make.height.greaterThanOrEqualTo(100)
        }
        self.topResultCard?.setupSubViews()
        self.topResultCard?.delegate = self
        
        // その他のベースとなるビュー
        self.otherResultsBaseView.backgroundColor = UIColor.clearColor()
        self.contentView.addSubview(self.otherResultsBaseView)
        self.otherResultsBaseView.snp_makeConstraints { (make) in
            make.top.equalTo(self.topResultCard!.snp_bottom)
            make.left.equalTo(self.topResultCard!)
            make.width.equalTo(self.topResultCard!)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.topResultCard!)
        }
        if self.restaurants.count < 2 {
            self.otherResultsBaseView.hidden = true
        } else {
            self.otherResultsBaseView.addSubview(self.secondRankHeader)
            self.secondRankHeader.snp_makeConstraints { (make) in
                make.left.equalTo(self.otherResultsBaseView)
                make.height.equalTo(32)
                make.width.equalTo(self.otherResultsBaseView)
                make.right.equalTo(self.otherResultsBaseView)
                make.top.equalTo(self.otherResultsBaseView).offset(18)
            }
            
            let otherRestaurants = [Restaurant](self.restaurants[1...self.restaurants.count-1])
            self.otherResultsCard = OtherResultsCard(frame: CGRectZero, restaurants: otherRestaurants, delegate: self)
            self.otherResultsCard!.delegate = self
            self.otherResultsBaseView.addSubview(self.otherResultsCard!)
            self.otherResultsCard!.snp_makeConstraints { (make) in
                make.width.equalTo(self.otherResultsBaseView)
                make.centerX.equalTo(self.otherResultsBaseView)
                make.top.equalTo(self.secondRankHeader.snp_bottom).offset(8)
                make.bottom.equalTo(self.otherResultsBaseView)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    // 結果が0件の時のレイアウト
    private func layoutNoResult() {
        let label = UILabel()
        label.text = NSLocalizedString("NoResultAlertTitle", comment: "")
        label.font = UIFont(name: Const.KARUTA_FONT_NORMAL, size: 17)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = UIColor.grayColor()
        self.contentView.addSubview(label)

        label.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // やり直すをタップした時の挙動
    func resetTapped() {
        self.delegate?.resultViewController(self, backButtonTappedWithReset: true)
    }
    
    // 続けるをタップした時の挙動
    func continueTapped() {
        self.delegate?.resultViewController(self, backButtonTappedWithReset: false)
    }

    //MARK: - Alerts
    // 結果無し時のアラート表示
    func showNoResultAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("NoResultAlertTitle", comment: ""),
            message: NSLocalizedString("NoResultAlertMessage", comment: ""),
            preferredStyle: .Alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func detailButtonTapped(restaurant: Restaurant) {
        let detailVC = DetailViewController(restaurant: restaurant)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}

// OtherResultCardDelegate method
extension ResultViewController: OtherResultCardDelegate {
    func contentTapped(restaurant: Restaurant) {
        let detailVC = DetailViewController(restaurant: restaurant)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
