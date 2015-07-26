//
//  Restaurant.swift
//  Karuta
//
//  Created by Kenzo on 2015/07/26.
//  Copyright (c) 2015年 Karuta. All rights reserved.
//

class Restaurant {
    let shopID: String
    let shopName: String
    let priceRange: String
    let distance: Double
    let imageUrls: [NSURL]
    
    init(shopID: String, shopName: String, priceRange: String, distance: Double, imageUrls: [NSURL]) {
        self.shopID = shopID
        self.shopName = shopName
        self.priceRange = priceRange
        self.distance = distance
        self.imageUrls = imageUrls
    }
}
