//
//  KRTMainViewController.swift
//  Karuta
//
//  Created by Kenzo on 2015/06/21.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Alamofire_SwiftyJSON

class KRTMainViewController: UIViewController {

    let locationManager: KRTLocationManager = KRTLocationManager()
    
    var isLocationAcquired = false
    var canCallNextCard = true
    
//    var stackedCard: KRTCardView

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.yellowColor()
        self.acquireFirstCard()
        println("start to get location..")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func acquireFirstCard() -> () {
        self.locationManager.fetchWithCompletion({ (location) -> () in
            println("success!!")
            self.acquireCardWithLatitude(Double(location!.coordinate.latitude),
                longitude: Double(location!.coordinate.longitude),
                like: nil,
                shopId: Int(INT_MAX),
                reset: true,
                success: {(Bool)->() in
                }
                ,
                failure: {(NSError)->() in
                }
            )
        }, failure: { (error) -> () in
            println("failure...")
        })
    }
    
    /**
    カードを取得
    */
    func acquireCardWithLatitude(latitude: Double, longitude: Double, like: String?, shopId: Int, reset: Bool, success: (Bool)->(), failure: (NSError)->()) {
        var params: Dictionary<String, AnyObject> = [
            "device_id" : KRTConst.deviceID,
            "latitude" : latitude,
            "longitude" : longitude,
            "shop_id" : "",
            "reset" : reset
        ]
        
        if (shopId != Int(INT_MAX)) {
            params.updateValue(shopId, forKey: "shop_id")
        }
        if ((like) != nil) {
            params.updateValue(like!, forKey: "answer")
        }
        
        Alamofire.request(.GET, KRTConst.API_CARD_BASE, parameters: params, encoding: .URL).responseSwiftyJSON({(request, response, json, error) in
            if error == nil {
                let card: JSON = json["card"]
                let shopName: String = card["title"].string!
                let shopImageUrl: NSURL = card["image_url"].URL!
                let shopID: Int = card["shop_id"].int!
                let maxPrice: Int = card["price_max"].int!
                let minPrice: Int = card["price_min"].int!
                let distance: Double = card["distance_meter"].double!

                success(json["result_available"].bool!)
            } else {
                println("fail to get card")
                failure(error!)
            }
        })
    }
    
    
//    - (BOOL)acquireCardWithLatitude:(double)latitude longitude:(double)longitude like:(NSString *)like shopId:(NSInteger)shopId reset:(BOOL)reset success: (void (^)(BOOL))success failure: (void (^)(NSError *))failure {
//    NSMutableDictionary *params = @{
//    @"device_id"    : 	DEVICE_ID,
//    @"latitude"     : 	[NSString stringWithFormat:@"%f",latitude],
//    @"longitude"    : 	[NSString stringWithFormat:@"%f",longitude],
//    @"shop_id"      : 	@"",
//    @"answer"       : 	@"",
//    @"reset"        :   @(reset)
//    }.mutableCopy;
//    
//    if (shopId != INT_MAX) {
//    params[@"shop_id"] = @(shopId);
//    }
//    if (like) {
//    params[@"answer"] = like;
//    }
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    BOOL hasResult = false;
//    [manager GET: API_CARD_BASE
//    parameters:params
//    success:^(NSURLSessionDataTask *task, id responseObject) {
//    // 通信に成功
//    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//    NSDictionary *cardDict = jsonDict[@"card"];
//    if (cardDict) {
//    NSString *shopName = cardDict[@"title"];
//    NSURL *shopImageUrl = [NSURL URLWithString:cardDict[@"image_url"]];
//    NSInteger shopID = [cardDict[@"shop_id"] integerValue];
//    NSInteger maxPrice = [cardDict[@"price_max"] integerValue];
//    NSInteger minPrice = [cardDict[@"price_min"] integerValue];
//    double distance = [cardDict[@"distance_meter"] doubleValue];
//    
//    self.stackedCard = [self createCardWithShopID:shopID
//    shopName:shopName
//    imageURL:shopImageUrl
//    maxPrice:maxPrice
//    minPrice:minPrice
//    distance:distance];
//    [self displayStackedCard];
//    }
//    success([[jsonDict valueForKey:@"result_available"] boolValue]);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//    NSLog(@"Error: %@", error);
//    failure(error);
//    }];
//    return hasResult;
//    }



}

