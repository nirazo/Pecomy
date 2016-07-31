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
    
    init(restaurantList: [Restaurant]) {
        super.init()
        self.restaurantList = restaurantList
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