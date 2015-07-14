//
//  MainViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON
import MDCSwipeToChoose
import SnapKit

class MainViewController: UIViewController, MDCSwipeToChooseDelegate {

    let locationManager: KarutaLocationManager = KarutaLocationManager()
    
    var isLocationAcquired = false
    var canCallNextCard = true
    var stackedCards = [CardView]()
    var currentLatitude: Double?
    var currentLongitude: Double?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = Const.KARUTA_TITLE
        
        // 背景画像設定（とりあえず固定で...）
        var image = UIImage(named: "Oimachi")
        UIGraphicsBeginImageContext(self.view.frame.size);
        image!.drawInRect(self.view.bounds)
        var backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        
        // ボタン配置
        var likeButton = UIButton()
        likeButton.setImage(UIImage(named: "like_normal"), forState: .Normal)
        likeButton.setImage(UIImage(named: "like_tapped"), forState: .Highlighted)
        likeButton.addTarget(self, action: "likeButtonTapped", forControlEvents: .TouchUpInside)
        
        var dislikeButton = UIButton()
        dislikeButton.setImage(UIImage(named: "dislike_normal"), forState: .Normal)
        dislikeButton.setImage(UIImage(named: "dislike_tapped"), forState: .Highlighted)
        dislikeButton.addTarget(self, action: "dislikeButtonTapped", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(likeButton)
        self.view.addSubview(dislikeButton)
        
        dislikeButton.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).multipliedBy(0.25)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.25)
            make.centerX.equalTo(self.view).offset(-self.view.frame.width/4)
            make.bottom.equalTo(self.view.snp_bottom).offset(-self.view.frame.width/4)
        }
        
        likeButton.snp_makeConstraints { (make) in
            make.width.equalTo(self.view).multipliedBy(0.25)
            make.height.equalTo(self.view.snp_width).multipliedBy(0.25)
            make.centerX.equalTo(self.view).offset(self.view.frame.width/4)
            make.bottom.equalTo(self.view.snp_bottom).offset(-self.view.frame.width/4)
        }
        
        self.acquireFirstCard()
        println("start to get location..")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Card related methods
    func acquireFirstCard() {
        self.locationManager.fetchWithCompletion({ (location) in
            println("success!!")
            self.currentLatitude = Double(location!.coordinate.latitude);
            self.currentLongitude = Double(location!.coordinate.longitude);
            self.acquireCardWithLatitude(Double(location!.coordinate.latitude),
                longitude: Double(location!.coordinate.longitude),
                like: nil,
                shopId: Int(INT_MAX),
                reset: true,
                success: {(Bool) in
                }
                ,
                failure: {(NSError) in
                }
            )
        }, failure: { (error) in
            println("failure...")
        })
    }
    
    /**
    カードを取得
    */
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String?, shopId: Int, reset: Bool, success: (Bool)->(), failure: (NSError)->()) -> Bool {
        var params: Dictionary<String, AnyObject> = [
            "device_id" : Const.DEVICE_ID,
//            "latitude" : latitude,
//            "longitude" : longitude,
            "latitude" : 35.607243,
            "longitude" : 139.734685,
            "shop_id" : "",
            "reset" : reset
        ]
        
        if (shopId != Int(INT_MAX)) {
            params.updateValue(shopId, forKey: "shop_id")
        }
        if ((like) != nil) {
            params.updateValue(like!, forKey: "answer")
        }
        
        var hasResult = false;
        Alamofire.request(.GET, Const.API_CARD_BASE, parameters: params, encoding: .URL).responseSwiftyJSON({(request, response, json, error) in
            if error == nil {
                // 店が見つかった場合場合
                if (json["message"] == nil) {
                    let card: JSON = json["card"]
                    let shopName: String = card["title"].string!
                    let shopImageUrl: NSURL = card["image_url"].URL!
                    let shopID: Int = card["shop_id"].int!
                    let maxPrice: Int = card["price_max"].int!
                    let minPrice: Int = card["price_min"].int!
                    let distance: Double = card["distance_meter"].double!
                    
                    let cardView = self.createCardWithShopID(shopID, shopName: shopName, imageURL: shopImageUrl, maxPrice: maxPrice, minPrice: minPrice, distance: distance)
                    self.stackedCards.append(cardView)
                    
                    // カード取得・表示については2枚取得する際に変更
                    self.displayStackedCard()
                    
                    hasResult = json["result_available"].bool!
                    success(hasResult)
                } else {
                    println("cannot find!")
                }
                
            } else {
                println("fail to get card")
                failure(error!)
            }
        })
        return hasResult
    }
    
    // カードを表示
    func displayStackedCard() {
        for card in self.stackedCards {
            self.view.addSubview(card)
            card.snp_makeConstraints { (make) in
                make.width.width.equalTo(self.view).multipliedBy(0.8)
                make.height.height.equalTo(self.view).multipliedBy(0.5)
                make.centerX.equalTo(self.view)
                make.centerY.equalTo(self.view).offset(-40)
            }
            println("card added!!")
        }
        self.stackedCards.removeAll()
    }
    
    // カードを作成
    func createCardWithShopID(shopID: Int, shopName: String, imageURL: NSURL, maxPrice: Int, minPrice: Int, distance: Double) -> CardView {
        var options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.onPan = { state in
            if (state.thresholdRatio == 1.0 && state.direction == .Left) {
                // 左スワイプ
            } else {
                // 右スワイプ
            }
        }
        let cardView = CardView(frame: CGRectZero, shopID: shopID, shopName: shopName, imageURL: imageURL, maxPrice: maxPrice, minPrice: minPrice, distance: distance, options: options)
        return cardView
    }
    
    // カード全部消す
    func resetCards() {
        for cv in self.view.subviews {
            if cv.dynamicType === CardView.self {
                cv.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Result related methods
    
    /**
    結果（ここへ行け！リスト）を取得
    */
    func acquireResults() {
        let params = ["device_id": Const.DEVICE_ID]
        Alamofire.request(.GET, Const.API_RESULT_BASE, parameters: params, encoding: .URL).responseSwiftyJSON({(request, response, json, error) in
            if error == nil {
                let results = json["results"]
                println("call present result!!")
                self.displayResultViewWithShopList(results)
            } else {
                println("failed to get result!!")
            }
        })
    }
    
    func displayResultViewWithShopList(shopList: JSON) {
        println("results: \(shopList)")
        var resultVC = ResultViewController(shopList: shopList)
        let backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        resultVC.navigationItem.title = "あなたのBEST"
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    

    func closeResult() {
        self.resetCards()
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: nil, shopId: Int(INT_MAX), reset: true, success: {(hasResult: Bool) in
            if (hasResult) {
                self.acquireResults()
            }
        },
            failure: {(error: NSError) in
        }
        )
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Button tapped Callbacks
    func likeButtonTapped() {
        self.swipeTopCardToWithDirection(.Right)
    }
    
    func dislikeButtonTapped() {
        self.swipeTopCardToWithDirection(.Left)
    }
    
    func swipeTopCardToWithDirection(direction: MDCSwipeDirection) {
        for cv in self.view.subviews {
            if let card = cv as? CardView {
                card.mdc_swipe(direction)
            }
        }
    }
    
    
    //MARK: - MDCSwipeToChooseDelegate Callbacks
    
    // This is called when a user didn't fully swipe left or right.
    func viewDidCancelSwipe(view: UIView!) {
        println("Couldn't decide, huh?")
    }
    
    // Sent before a choice is made. Cancel the choice by returning `NO`. Otherwise return `YES`.
    func view(view: UIView!, shouldBeChosenWithDirection direction: MDCSwipeDirection) -> Bool {
        if (direction == .Left || direction == .Right) {
            return true
        } else {
            UIView.animateWithDuration(0.16, animations: {() in
                view.transform = CGAffineTransformIdentity
                view.center = view.superview!.center
            })
            return false
        }
    }
    
    
    // This is called then a user swipes the view fully left or right.
    func view(view: UIView!, wasChosenWithDirection direction: MDCSwipeDirection) {
        var answer = "dislike"
        if (direction == .Right) {
            answer = "like"
        }
        var cardView = view as! CardView
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: answer, shopId: cardView.shopID!, reset: false,
            success: {(hasResult: Bool) in
                if (hasResult) {
                    self.acquireResults()
                }
            }, failure: {(error: NSError) in
            }
        )
    }
    
}

