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
//import Alamofire_SwiftyJSON
import MDCSwipeToChoose
import SnapKit

class MainViewController: UIViewController, MDCSwipeToChooseDelegate {

    let locationManager: KarutaLocationManager = KarutaLocationManager()
    
    var contentView = UIView()
    
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
        
        // カードを配置するための透明ビュー
        contentView.frame = self.view.frame
        contentView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(self.contentView)
        
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
//            self.currentLatitude = 35.607762
//            self.currentLongitude = 139.734562
            
            self.acquireCardWithLatitude(Double(self.currentLatitude!),
                longitude: Double(self.currentLongitude!),
                like: nil,
                syncId: nil,
                reset: true,
                success: {(Bool) in
                    // とりあえず直で2回呼びます
                    self.acquireCardWithLatitude(Double(self.currentLatitude!),
                        longitude: Double(self.currentLongitude!),
                        like: nil,
                        syncId: nil,
                        reset: false,
                        success: {(Bool) in
                            
                        }
                        ,
                        failure: {(NSError) in
                        }
                    )
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
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String?, syncId: String?, reset: Bool, success: (Bool)->(), failure: (NSError)->()) -> Bool {
        var params: Dictionary<String, AnyObject> = [
            "device_id" : Const.DEVICE_ID,
            "latitude" : latitude,
            "longitude" : longitude,
            "reset" : reset
        ]
        
        if (syncId != nil) {
            params.updateValue(syncId!, forKey: "sync_id")
        }
        if ((like) != nil) {
            params.updateValue(like!, forKey: "answer")
        }
        
        var hasResult = false;
        
        Alamofire.request(.GET, Const.API_CARD_BASE, parameters: params, encoding: .URL).responseJSON {(request, response, data, error) in
            var json = JSON.nullJSON
            if error == nil && data != nil {
                json = SwiftyJSON.JSON(data!)
                // 店が見つかった場合
                println("response data: \(json)")
                if (json["message"] == nil) {
                    let card: JSON = json["card"]
                    let shopName = card["title"].string!
                    let shopImageUrlsString = card["image_url"].array!
                    let maxPrice = card["price_max"].int!
                    let minPrice = card["price_min"].int!
                    let distance: Double = card["distance_meter"].double!
                    
                    var shopImageUrls = [NSURL]()
                    for urlString in shopImageUrlsString {
                        shopImageUrls.append(NSURL(string: urlString.string!)!)
                    }
                    
                    let syncID: String! = json["sync_id"].string!
                    
                    var rect = CGRect(x: 0, y: 0, width: self.view.frame.width*0.8, height: self.view.frame.height*0.5)
                    
                    rect.offset(dx: (self.view.frame.width - rect.size.width)/2, dy: (self.view.frame.height - rect.size.height)/2 - 40)
                    
                    let cardView = self.createCardWithFrame(rect, syncID: syncID!, shopName: shopName, imageUrls: shopImageUrls, maxPrice: maxPrice, minPrice: minPrice, distance: distance)
                    self.stackedCards.append(cardView)
                    
                    // カード取得・表示については2枚取得する際に変更
                    self.displayStackedCard()
                    
                    hasResult = json["result_available"].bool!
                    success(hasResult)
                } else {
                    println("cannot find!")
                }
            
            println("url: \(request)")
            
            } else {
                println("fail to get card")
                failure(error!)
            }
        }
        return hasResult
    }
    
    // カードを表示
    func displayStackedCard() {
        for card in self.stackedCards {
            self.contentView.addSubview(card)
            self.contentView.sendSubviewToBack(card)
        }
        self.stackedCards.removeAll()
    }
    
    // カードを作成
    func createCardWithFrame(frame: CGRect, syncID: String, shopName: String, imageUrls: [NSURL], maxPrice: Int, minPrice: Int, distance: Double) -> CardView {
        var options = MDCSwipeToChooseViewOptions()
        options.delegate = self
        options.onPan = { state in
            if (state.thresholdRatio == 1.0 && state.direction == .Left) {
                // 左スワイプ
            } else {
                // 右スワイプ
            }
        }
        let cardView = CardView(frame: frame, syncID: syncID, shopName: shopName, imageUrls: imageUrls, maxPrice: maxPrice, minPrice: minPrice, distance: distance, options: options)
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
        
        Alamofire.request(.GET, Const.API_RESULT_BASE, parameters: params, encoding: .URL).responseJSON {(request, response, data, error) in
            var json = JSON.nullJSON
            if error == nil && data != nil {
                json = SwiftyJSON.JSON(data!)
                let results = json["results"]
                println("call present result!!")
                self.displayResultViewWithShopList(results)
            } else {
                println("failed to get result!!")
            }
        }
    }
    
    func displayResultViewWithShopList(shopList: JSON) {
        var resultVC = ResultViewController(shopList: shopList)
        let backButton = UIBarButtonItem(title: "戻る", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        resultVC.navigationItem.title = "あなたのBEST"
        
        // カードリセットしてnew card呼び出し
        self.resetCards()
        self.acquireFirstCard()
        
        self.navigationController?.pushViewController(resultVC, animated: true)
    }
    

    func closeResult() {
        self.resetCards()
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: nil, syncId: nil, reset: true, success: {(hasResult: Bool) in
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
        if (self.contentView.subviews.count > 0) {
            var card = self.contentView.subviews[self.contentView.subviews.count-1] as! CardView
            card.mdc_swipe(direction)
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
                //view.center = view.superview!.center
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
        self.acquireCardWithLatitude(self.currentLatitude!, longitude: self.currentLongitude!, like: answer, syncId: cardView.syncID, reset: false,
            success: {(hasResult: Bool) in
                if (hasResult) {
                    self.acquireResults()
                }
            }, failure: {(error: NSError) in
            }
        )
    }
    
}

