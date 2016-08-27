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
    
    var dayPriceRange: String {
        get {
            var price = ""
            let pattern = "\\[昼\\](?!.*  ).+?999"
            let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            let matches: [NSTextCheckingResult] = regex.matchesInString(self.priceRange, options: [], range: NSMakeRange(0, self.priceRange.characters.count))
            for (idx, match) in matches.enumerate() {
                price = NSString(string: self.priceRange).substringWithRange(match.rangeAtIndex(idx))
            }
            return String(price)
        }
    }
    
    // [昼]を消したdayRange
    var dayPriceRangeWithoutLabel: String {
        get {
            return self.dayPriceRange.stringByReplacingOccurrencesOfString("[昼]", withString: "")
        }
    }
    
    var nightPriceRange: String {
        get {
            var price = ""
            let pattern = "\\[夜\\][^  ].+?999"
            let regex = try! NSRegularExpression(pattern: pattern, options: .CaseInsensitive)
            let matches: [NSTextCheckingResult] = regex.matchesInString(self.priceRange, options: [], range: NSMakeRange(0, self.priceRange.characters.count))
            for (idx, match) in matches.enumerate() {
                price = NSString(string: self.priceRange).substringWithRange(match.rangeAtIndex(idx))
            }
            return String(price)
        }
    }
    
    // [夜]を消したnightPriceRange
    var nightPriceRangeWithoutLabel: String {
        get {
            return self.nightPriceRange.stringByReplacingOccurrencesOfString("[夜]", withString: "")
        }
    }
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
    }
}