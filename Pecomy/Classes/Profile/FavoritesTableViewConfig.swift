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
    
    func updateFavoritesList(_ completion: (()->())? = nil) {
        self.favoritesModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let user):
                strongSelf.sectionedRestaurantList = strongSelf.createSectionedRestaurantList(user.favorites)
                completion?()
            case .failure(let error):
                print("error: \(error.code), \(String(describing: error.response))")
            }
            })
    }
    
    fileprivate func createSectionedRestaurantList(_ list: [Restaurant]) -> [String: [Restaurant]] {
        var sectionedList = [String: [Restaurant]]()
        list.forEach { restaurant in
            let dateStr = Utils.dateStringToShort(restaurant.timestamp)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return Array(self.sectionedRestaurantList.keys).count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyArray = Array(self.sectionedRestaurantList.keys).sorted {$0 > $1 }
        guard let array = self.sectionedRestaurantList[keyArray[section]] else { return 0 }
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesReuseIdentifier", for: indexPath) as! RestaurantListCell
        let keyArray = Array(self.sectionedRestaurantList.keys).sorted { $0 > $1 }
        let restaurant = self.sectionedRestaurantList[keyArray[indexPath.section]]![indexPath.row]
        cell.configureCell(restaurant, type: .favorites)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var keys = Array(self.sectionedRestaurantList.keys).sorted { $0 > $1 }
        return keys[section]
    }
}
