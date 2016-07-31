//
//  Restaurant.swift
//  Pecomy
//
//  Created by Kenzo on 2015/12/29.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation
import ObjectMapper

struct Restaurant {
    var shopID: Int = 0
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
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var businessHours = ""
    var tel = ""
    var visits: Int = 0
    var favorite = false
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
        tel <- map["tel"]
        visits <- map["visits"]
        favorite <- map["favorite"]
    }
}