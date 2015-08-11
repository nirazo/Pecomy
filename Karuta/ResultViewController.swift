//
//  ResultViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/08/09.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    // 結果同士のマージン
    let RESULT_MARGIN: CGFloat = 15

    var restaurants: [Restaurant]
    
    var topResultCard: TopResultCard?
    
    init(restaurants: [Restaurant]) {
        self.restaurants = restaurants
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.edgesForExtendedLayout = .None
        
        
        // 1位
        self.topResultCard = TopResultCard(frame: CGRectZero, restaurant: self.restaurants[0])
        let tr = UITapGestureRecognizer(target: self, action: "resultTapped:")
        self.topResultCard?.addGestureRecognizer(tr)
        self.view.addSubview(topResultCard!)
        
        switch self.restaurants.count {
        case 1:
            layoutOneResult()
        case 2:
            layoutTwoResults()
        case 3:
            layoutThreeResults()
        default:
            break
        }
        self.view.setNeedsDisplay()
    }
    
    // 結果が1個の時のレイアウト
    private func layoutOneResult() {
        topResultCard!.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-RESULT_MARGIN*2)
            make.height.equalTo(self.view).offset(-RESULT_MARGIN*2)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(RESULT_MARGIN)
            make.bottom.equalTo(self.view).offset(-RESULT_MARGIN)
        }
    }
    
    // 結果が2個の時のレイアウト
    private func layoutTwoResults() {
        topResultCard!.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-RESULT_MARGIN*2)
            make.height.equalTo(self.view).multipliedBy(0.55)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(RESULT_MARGIN)
        }
        
        var secondResultCard: OtherResultCard
        secondResultCard = OtherResultCard(frame: CGRectZero, restaurant: self.restaurants[1], rank: 2)
        let tr = UITapGestureRecognizer(target: self, action: "resultTapped:")
        secondResultCard.addGestureRecognizer(tr)
        self.view.addSubview(secondResultCard)
        secondResultCard.snp_makeConstraints { (make) in
            make.left.equalTo(topResultCard!)
            make.width.equalTo(topResultCard!)
            make.top.equalTo(topResultCard!.snp_bottom).offset(RESULT_MARGIN)
            make.bottom.equalTo(self.view).offset(-RESULT_MARGIN)
        }
    }
    
    // 結果が3個の時のレイアウト
    private func layoutThreeResults() {
        topResultCard!.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).offset(-RESULT_MARGIN*2)
            make.height.equalTo(self.view).multipliedBy(0.55)
            make.centerX.equalTo(self.view)
            make.top.equalTo(self.view).offset(RESULT_MARGIN)
        }
        
        var secondResultCard = OtherResultCard(frame: CGRectZero, restaurant: self.restaurants[1], rank: 2)
        let tr_second = UITapGestureRecognizer(target: self, action: "resultTapped:")
        secondResultCard.addGestureRecognizer(tr_second)
        self.view.addSubview(secondResultCard)
        secondResultCard.snp_makeConstraints { (make) in
            make.left.equalTo(topResultCard!)
            make.width.equalTo(topResultCard!).multipliedBy(0.50).offset(-RESULT_MARGIN/2)
            make.top.equalTo(topResultCard!.snp_bottom).offset(RESULT_MARGIN)
            make.bottom.equalTo(self.view).offset(-RESULT_MARGIN)
        }
        
        // 3位
        var thirdResultCard = OtherResultCard(frame: CGRectZero, restaurant: self.restaurants[2], rank: 3)
        let tr_third = UITapGestureRecognizer(target: self, action: "resultTapped:")
        thirdResultCard.addGestureRecognizer(tr_third)
        self.view.addSubview(thirdResultCard)
        thirdResultCard.snp_makeConstraints { (make) in
            make.left.equalTo(secondResultCard.snp_right).offset(RESULT_MARGIN)
            make.width.equalTo(secondResultCard)
            make.height.equalTo(secondResultCard)
            make.top.equalTo(secondResultCard)
            make.bottom.equalTo(secondResultCard)
        }
    }
    
    override func viewDidLayoutSubviews() {
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

}
