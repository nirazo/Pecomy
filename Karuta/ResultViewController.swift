//
//  ResultViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import Alamofire

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
    
    var otherResultCard: OtherResultCardContentView?
    
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
        case 1:
            self.prepareLayout()
        default:
            self.prepareLayout()
            self.layoutOthers()
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
//        guard let otherCard = self.otherResultCard else {
//            return
//        }
//        self.scrollView.snp_makeConstraints{ (make) in
//            make.height.greaterThanOrEqualTo(600)
//            make.bottom.equalTo(otherCard)
//        }
//        self.view.layoutIfNeeded()
        
        self.scrollView.contentSize = self.contentView.frame.size
        print("scrollView: \(scrollView.frame.size)")
        print("scrollView.contentSize: \(scrollView.contentSize)")
        print("contentView: \(self.contentView.frame.size)")
    }
    
    // レイアウト共通(結果が存在する場合)
    private func prepareLayout() {
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 32, 0)
        self.scrollView.backgroundColor = UIColor.yellowColor()
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
            make.height.greaterThanOrEqualTo(500)
        }
        
        // 1位
        self.contentView.addSubview(self.firstRankHeader)
        self.firstRankHeader.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.height.equalTo(32)
            make.width.equalTo(self.contentView).offset(-32)
            make.right.equalTo(self.contentView).offset(16)
            make.top.equalTo(self.contentView).offset(16)
        }
        
        self.topResultCard = TopResultCard(frame: CGRectZero, restaurant: self.restaurants[0], delegate: self)
        self.contentView.addSubview(topResultCard!)
        self.topResultCard!.snp_makeConstraints { (make) in
            make.width.equalTo(self.contentView).offset(-RESULT_MARGIN*2)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.firstRankHeader.snp_bottom).offset(8)
        }
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
    
    // 結果が2件以上ある時のレイアウト
    private func layoutOthers() {
        guard let topCard = self.topResultCard else {
            return
        }
        
        self.contentView.addSubview(self.secondRankHeader)
        self.secondRankHeader.snp_makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(16)
            make.height.equalTo(32)
            make.width.equalTo(self.contentView).offset(-32)
            make.right.equalTo(self.contentView).offset(16)
            make.top.equalTo(topCard.snp_bottom).offset(18)
        }
        
        self.otherResultCard = OtherResultCardContentView(frame: CGRectZero, restaurant: self.restaurants[1], delegate: self)
        self.contentView.addSubview(self.otherResultCard!)
        self.otherResultCard!.snp_makeConstraints { (make) in
            make.width.equalTo(self.contentView).offset(-RESULT_MARGIN*2)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.secondRankHeader.snp_bottom).offset(8)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 結果をタップした時の挙動
    func resultTapped(sender:UITapGestureRecognizer) {
        let resultCard = sender.view as! ResultCardBase
        let detailView = RestaurantDetailViewController(url: resultCard.url)
        self.navigationController?.pushViewController(detailView, animated: true)
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
    
    //MARK: - ResultCardBaseDelegate
//    func goodButtonTapped(card: ResultCardBase, shopID: String) {
//        let ac = UIAlertController(title: "", message: NSLocalizedString("GoodButtonSendMessage", comment: ""), preferredStyle: .Alert)
//        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
//            style: .Default, handler: { (action) in
//                let params = ["shop_id": shopID, "device_id": Utils.acquireDeviceID()]
//                Alamofire.request(.GET, Const.API_GOOD_BASE, parameters: params, encoding: .URL).responseJSON {(request, response, result) in
//                    switch result {
//                    case .Success(_):
//                        break
//                    case .Failure(_, _):
//                        // 現時点ではAPIが無いので、404を正とする
//                        if (response?.statusCode == Const.STATUS_CODE_NOT_FOUND) {
//                            card.goodButton.enabled = false
//                        }
//                        break
//                    }
//                }
//            }
//        )
//        let cancelAction = UIAlertAction(title: NSLocalizedString("Back", comment: ""),
//            style: .Default, handler: nil)
//        ac.addAction(cancelAction)
//        ac.addAction(okAction)
//        self.presentViewController(ac, animated: true, completion: nil)
//    }
    
    func detailButtonTapped(card: ResultCardBase) {
        let detailView = RestaurantDetailViewController(url: card.url)
        self.navigationController?.pushViewController(detailView, animated: true)
    }

}
