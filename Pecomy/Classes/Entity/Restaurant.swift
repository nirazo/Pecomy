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
    var priceRange = ""
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
    var timestamp = ""
    
    var dayPriceRange: String {
        get {
            var price = ""
            let pattern = "\\[昼\\](?!.*  ).+?999"
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches: [NSTextCheckingResult] = regex.matches(in: self.priceRange, options: [], range: NSMakeRange(0, self.priceRange.count))
            for (idx, match) in matches.enumerated() {
                price = NSString(string: self.priceRange).substring(with: match.range(at: idx))
            }
            return String(price)
        }
    }
    
    // [昼]を消したdayRange
    var dayPriceRangeWithoutLabel: String {
        get {
            return self.dayPriceRange.replacingOccurrences(of: "[昼]", with: "")
        }
    }
    
    var nightPriceRange: String {
        get {
            var price = ""
            let pattern = "\\[夜\\][^  ].+?999"
            let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let matches: [NSTextCheckingResult] = regex.matches(in: self.priceRange, options: [], range: NSMakeRange(0, self.priceRange.count))
            for (idx, match) in matches.enumerated() {
                price = NSString(string: self.priceRange).substring(with: match.range(at: idx))
            }
            return String(price)
        }
    }
    
    // [夜]を消したnightPriceRange
    var nightPriceRangeWithoutLabel: String {
        get {
            return self.nightPriceRange.replacingOccurrences(of: "[夜]", with: "")
        }
    }
}

extension Restaurant: Mappable {
    init?(map: Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map: Map) {
        shopID <- map["shop_id"]
        shopName <- map["title"]
        dayPriceMin <- map["price_min_day"]
        dayPriceMax <- map["price_max_day"]
        nightPriceMin <- map["price_min_night"]
        nightPriceMax <- map["price_max_night"]
        priceRange <- map["price_range"]
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
        timestamp <- map["timestamp"]
    }
}
