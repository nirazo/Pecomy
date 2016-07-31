//
//  VisitsTableViewConfig.swift
//  Pecomy
//
//  Created by Kenzo on 7/31/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

class VisitsTableViewConfig: NSObject {
    var restaurantList = [Restaurant]()
    let visitsModel = VisitsModel()
    
    init(restaurantList: [Restaurant]) {
        super.init()
        self.restaurantList = restaurantList
    }
    
    func updateVisitsList(completion: (()->())? = nil) {
        self.visitsModel.fetch(AppState.sharedInstance.currentLatitude ?? 0.0, longitude: AppState.sharedInstance.currentLongitude ?? 0.0, orderBy: .Recent, handler: {[weak self](result: PecomyResult<PecomyUser, PecomyApiClientError>) in
            guard let strongSelf = self else { return }
            switch result {
            case .Success(let user):
                print("visits: \(user.visits)")
                strongSelf.restaurantList = user.visits
                completion?()
            case .Failure(let error):
                print("error: \(error.code), \(error.response)")
            }
            })
    }
}

extension VisitsTableViewConfig: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("visitsReuseIdentifier", forIndexPath: indexPath) as! RestaurantListCell
        cell.configureCell(self.restaurantList[indexPath.row])
        return cell
    }
}