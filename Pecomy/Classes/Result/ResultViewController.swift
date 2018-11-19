//
//  ResultViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2016 Pecomy. All rights reserved.
//

import UIKit
import Alamofire
import SnapKit

protocol ResultViewControllerDelegate {
    func resultViewController(_ controller: ResultViewController, backButtonTappedWithReset reset: Bool)
}

class ResultViewController: UIViewController {
    
    let ANALYTICS_TRACKING_CODE = AnaylyticsTrackingCode.ResultViewController.rawValue
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    // 結果同士のマージン
    let RESULT_MARGIN: CGFloat = 16

    let restaurants: [Restaurant]
    
    let displayMessage: String
    
    var topResultCard: TopResultCard?
    
    var otherResultsCard: OtherResultsCard?
    
    var otherResultsBaseView = UIView()
    
    let topHeaderBaseView = UIView()
    
    let firstRankHeader = ResultHeaderView(frame: .zero, section: 0)
    
    let secondRankHeader = ResultHeaderView(frame: .zero, section: 1)
    
    var commentView: CommentContentView?
    
    var delegate: ResultViewControllerDelegate?
    
    init(restaurants: [Restaurant], displayMessage: String) {
        self.restaurants = restaurants
        self.displayMessage = displayMessage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Const.PECOMY_RESULT_BACK_COLOR
        
        self.navigationController?.makeNavigationBarDefault()
        
        if (displayMessage.isEmpty) {
            let continueButton = UIBarButtonItem(title: R.string.localizable.continueString(), style: .plain, target: self, action: #selector(continueTapped))
            self.navigationItem.leftBarButtonItem = continueButton
        } else {
            let resetButton = UIBarButtonItem(title: R.string.localizable.reset(), style: .plain, target: self, action: #selector(resetTapped))
            self.navigationItem.leftBarButtonItem = resetButton
        }
        
        switch self.restaurants.count {
        case 0:
            self.layoutNoResult()
            self.showNoResultAlert()
        default:
            self.setupLayout()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = self.contentView.frame.size
    }
    
    // 結果が存在する場合のレイアウト
    fileprivate func setupLayout() {
        self.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 32, right: 0)
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view)
            make.height.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.scrollView.addSubview(self.contentView)
        self.contentView.snp.makeConstraints { (make) in
            make.width.equalTo(self.scrollView)
            make.centerX.equalTo(self.scrollView)
            make.top.equalTo(self.scrollView)
        }
        
        self.topHeaderBaseView.backgroundColor = .clear
        self.contentView.addSubview(self.topHeaderBaseView)
        self.topHeaderBaseView.snp.makeConstraints { make in
            make.top.equalTo(self.contentView)
            make.width.equalTo(self.contentView)
            make.centerX.equalTo(self.contentView)
            make.height.greaterThanOrEqualTo(10)
        }
        
        if (!self.displayMessage.isEmpty) {
            let messageLabelView = ResultMessageHeaderView(message: self.displayMessage)
            self.topHeaderBaseView.addSubview(messageLabelView)
            messageLabelView.snp.makeConstraints { make in
                make.top.equalTo(self.topHeaderBaseView)
                make.left.equalTo(self.topHeaderBaseView)
                make.bottom.equalTo(self.topHeaderBaseView)
                make.right.equalTo(self.topHeaderBaseView)
                make.height.greaterThanOrEqualTo(20)
            }
        } else {
            // 1位
            self.topHeaderBaseView.addSubview(self.firstRankHeader)
            self.firstRankHeader.snp.makeConstraints { make in
                make.top.equalTo(self.topHeaderBaseView).offset(16)
                make.left.equalTo(self.topHeaderBaseView).offset(16)
                make.right.equalTo(self.topHeaderBaseView).offset(-16)
                make.bottom.equalTo(self.topHeaderBaseView)
                make.height.equalTo(55)
            }
        }
        self.topResultCard = TopResultCard.instance()
        self.topResultCard?.setup(self.restaurants[0])
        self.contentView.addSubview(topResultCard!)
        self.topResultCard?.snp.makeConstraints { make in
            make.width.equalTo(self.contentView).offset(-RESULT_MARGIN*2)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.topHeaderBaseView.snp.bottom).offset(8)
            make.height.greaterThanOrEqualTo(100)
        }
        self.topResultCard?.setupSubViews()
        self.topResultCard?.delegate = self
        
        var reviewSubject = ""
        var commentViewHeight = 0
        if (!self.restaurants[0].reviewSubjects.isEmpty) {
            reviewSubject = self.restaurants[0].reviewSubjects[0]
            commentViewHeight = 40
        }
        self.commentView = CommentContentView(frame: .zero, comment: reviewSubject, backgroundColor: Const.PECOMY_RANK_COLOR[0], textColor: .white)
        self.contentView.addSubview(self.commentView!)
        self.commentView?.snp.makeConstraints{ (make) in
            make.top.equalTo(self.topResultCard!.snp.bottom).offset(10)
            make.left.equalTo(self.topResultCard!)
            make.width.equalTo(self.topResultCard!)
            make.height.equalTo(commentViewHeight)
        }
        
        // その他のベースとなるビュー
        self.otherResultsBaseView.backgroundColor = .clear
        self.contentView.addSubview(self.otherResultsBaseView)
        self.otherResultsBaseView.snp.makeConstraints { (make) in
            make.top.equalTo(self.commentView!.snp.bottom)
            make.left.equalTo(self.topResultCard!)
            make.width.equalTo(self.topResultCard!)
            make.bottom.equalTo(self.contentView)
            make.right.equalTo(self.topResultCard!)
        }
        if self.restaurants.count < 2 {
            self.otherResultsBaseView.isHidden = true
        } else {
            self.otherResultsBaseView.addSubview(self.secondRankHeader)
            self.secondRankHeader.snp.makeConstraints { (make) in
                make.left.equalTo(self.otherResultsBaseView)
                make.height.equalTo(55)
                make.width.equalTo(self.otherResultsBaseView)
                make.right.equalTo(self.otherResultsBaseView)
                make.top.equalTo(self.otherResultsBaseView).offset(18)
            }
            let otherRestaurants = [Restaurant](self.restaurants[1...self.restaurants.count-1])
            self.otherResultsCard = OtherResultsCard(frame: .zero, restaurants: otherRestaurants, delegate: self)
            self.otherResultsCard!.delegate = self
            self.otherResultsBaseView.addSubview(self.otherResultsCard!)
            self.otherResultsCard!.snp.makeConstraints { (make) in
                make.width.equalTo(self.otherResultsBaseView)
                make.centerX.equalTo(self.otherResultsBaseView)
                make.top.equalTo(self.secondRankHeader.snp.bottom).offset(8)
                make.bottom.equalTo(self.otherResultsBaseView)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    // 結果が0件の時のレイアウト
    fileprivate func layoutNoResult() {
        let label = UILabel()
        label.text = NSLocalizedString("NoResultAlertTitle", comment: "")
        label.font = UIFont(name: Const.PECOMY_FONT_NORMAL, size: 17)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .gray
        self.contentView.addSubview(label)

        label.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // 続けるをタップした時の挙動
    @objc func continueTapped() {
        self.delegate?.resultViewController(self, backButtonTappedWithReset: false)
    }
    
    // ゲーム画面に戻ってresetする場合
    @objc func resetTapped() {
        self.delegate?.resultViewController(self, backButtonTappedWithReset: true)
    }

    //MARK: - Alerts
    // 結果無し時のアラート表示
    func showNoResultAlert() {
        let alertController = UIAlertController(title:NSLocalizedString("NoResultAlertTitle", comment: ""),
            message: NSLocalizedString("NoResultAlertMessage", comment: ""),
            preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
            style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func openDetailViewController(_ restaurant: Restaurant) {
        let detailVC = DetailViewController(restaurant: restaurant)
        detailVC.navigationItem.title = restaurant.shopName
        let backButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    fileprivate func displayAlertWithMessage(_ message: String) {
        let alertController = UIAlertController(title:nil,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""),
                                     style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK:- OtherResultCardDelegate method
extension ResultViewController: OtherResultCardDelegate {
    func contentTapped(_ restaurant: Restaurant) {
        self.openDetailViewController(restaurant)
    }
}

extension ResultViewController: ResultCardBaseDelegate {
    func detailButtonTapped(_ restaurant: Restaurant) {
        self.openDetailViewController(restaurant)
    }
}
