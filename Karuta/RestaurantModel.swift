//
//  Restaurant.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/26.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

class RestaurantModel {
    let shopID: String
    let shopName: String
    let priceRange: String
    let distance: Double
    let imageUrls: [NSURL?]
    let url: NSURL
    let category: String
    
    init(shopID: String, shopName: String, priceRange: String, distance: Double, imageUrls: [NSURL?], url: NSURL, category: String) {
        self.shopID = shopID
        self.shopName = shopName
        self.priceRange = priceRange
        self.distance = distance
        self.imageUrls = imageUrls
        self.url = url
        self.category = category
    }
}
