//
//  FavoritesTableViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 7/31/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class FavoritesTableViewConfig: NSObject {
    var sectionedRestaurantList = [String: [Restaurant]]()
    let favoritesModel = FavoritesModel()
    
    init(restaurantList: [Restaurant]) {
        super.init()
        self.sectionedRestaurantList = self.createSectionedRestaurantList(restaurantList)
    }
    
    func updateFavoritesList(completion: (()->())? = nil) {
        self.favoritesModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                strongSelf.sectionedRestaurantList = strongSelf.createSectionedRestaurantList(user.favorites)
                completion?()
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
    }
    
    private func createSectionedRestaurantList(list: [Restaurant]) -> [String: [Restaurant]] {
        var sectionedList = [String: [Restaurant]]()
        list.forEach { restaurant in
            let dateStr = Utils.dateStringToShortDateString(restaurant.timestamp)
            let keyArray = Array(sectionedList.keys)
            if (keyArray.contains(dateStr)) {
                sectionedList[dateStr]?.append(restaurant)
            } else {
                sectionedList.updateValue([restaurant], forKey: dateStr)
            }
        }
        return sectionedList
    }
}

extension FavoritesTableViewConfig: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Array(self.sectionedRestaurantList.keys).count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyArray = Array(self.sectionedRestaurantList.keys).sort {$0 > $1 }
        guard let array = self.sectionedRestaurantList[keyArray[section]] else { return 0 }
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoritesReuseIdentifier", forIndexPath: indexPath) as! RestaurantListCell
        let keyArray = Array(self.sectionedRestaurantList.keys).sort { $0 > $1 }
        let restaurant = self.sectionedRestaurantList[keyArray[indexPath.section]]![indexPath.row]
        cell.configureCell(restaurant, type: .Favorites)
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var keys = Array(self.sectionedRestaurantList.keys).sort { $0 > $1 }
        return keys[section]
    }
}