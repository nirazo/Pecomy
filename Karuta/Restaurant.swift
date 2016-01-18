//
//  Restaurant.swift
//  Karuta
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2015年 Karuta. All rights reserved.
//

import Foundation
import ObjectMapper

struct Restaurant {
    var shopID = ""
    var shopName = ""
    var dayPriceMin = ""
    var dayPriceMax = ""
    var nightPriceMin = ""
    var nightPriceMax = ""
    var distance: Double = 0.0
    var imageUrls = [String]()
    var url = ""
    var category = ""
    var richTags = [String]()
    var reviewSubjects = [String]()
    var holidays = ""
    var latitude = ""
    var longitude = ""
    var businessHours = ""
}

extension Restaurant: Mappable {
    init?(_ map: Map) {
        mapping(map)
    }
    
    mutating func mapping(map: Map) {
        shopID <- map["shop_id"]
        shopName <- map["title"]
        dayPriceMin <- map["price_min_day"]
        dayPriceMax <- map["price_max_day"]
        nightPriceMin <- map["price_min_night"]
        nightPriceMax <- map["price_max_night"]
        distance <- map["distance_meter"]
        imageUrls <- map["image_url"]
        url <- map["url"]
        category <- map["top_category"]
        richTags <- map["rich_tags"]
        reviewSubjects <- map["review_subjects"]
        holidays <- map["holidays"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        businessHours <- map["business_hours"]
    }
}