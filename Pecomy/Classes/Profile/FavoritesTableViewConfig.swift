//
//  FavoritesTableViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 7/31/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class FavoritesTableViewConfig: NSObject {
    var restaurantList = [Restaurant]()
    let favoritesModel = FavoritesModel()
    
    init(restaurantList: [Restaurant]) {
        super.init()
        self.restaurantList = restaurantList
    }
    
    func updateFavoritesList(completion: (()->())? = nil) {
        self.favoritesModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                strongSelf.restaurantList = user.favorites
                completion?()
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
    }
}

extension FavoritesTableViewConfig: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoritesReuseIdentifier", forIndexPath: indexPath) as! RestaurantListCell
        cell.configureCell(self.restaurantList[indexPath.row], type: .Favorites)
        return cell
    }
}