//
//  FavoritesAndVisitsViewController.swift
//  Pecomy
//
//  Created by Kenzo on 7/24/16.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import Foundation

enum RestaurantListType {
    case favorites, visits, none
}

class FavoritesAndVisitsViewController: UIViewController {
    let favoritesCellIdentifier = "favoritesReuseIdentifier"
    let visitsCellIdentifier = "visitsReuseIdentifier"
    
    let favoritesTableView = UITableView()
    let visitsTableView = UITableView()
    var listType: RestaurantListType
    let favoritesConfig: FavoritesTableViewConfig
    let visitsConfig: VisitsTableViewConfig
    let segmentedControl = UISegmentedControl(items: [NSLocalizedString("Favorite", comment: ""), NSLocalizedString("Checkin", comment: "")])
    
    init(type: RestaurantListType, favoritesList: [Restaurant], visitsList: [Restaurant]) {
        self.listType = type
        self.favoritesConfig = FavoritesTableViewConfig(restaurantList: favoritesList)
        self.visitsConfig = VisitsTableViewConfig(restaurantList: visitsList)
        super.init(nibName: nil, bundle: nil)
        
        // TableView初期設定
        self.favoritesTableView.delegate = self
        self.favoritesTableView.dataSource = self.favoritesConfig
        self.favoritesTableView.register(RestaurantListCell.self, forCellReuseIdentifier: self.favoritesCellIdentifier)
        self.visitsTableView.delegate = self
        self.visitsTableView.dataSource = self.visitsConfig
        self.visitsTableView.register(RestaurantListCell.self, forCellReuseIdentifier: self.visitsCellIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.makeNavigationBarDefault()
        self.edgesForExtendedLayout = []
        
        let backButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        
        // segmentedControl
        self.segmentedControl.sizeToFit()
        self.segmentedControl.selectedSegmentIndex = self.listType.hashValue
        self.segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        self.navigationItem.titleView = self.segmentedControl
        
        self.view.addSubview(self.currentTableView(self.listType))
        self.currentTableView(self.listType).snp.remakeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        self.view.backgroundColor = .red
        self.favoritesTableView.estimatedRowHeight = 80
        self.visitsTableView.estimatedRowHeight = 80
        self.currentTableView(self.listType).reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favoritesConfig.updateFavoritesList { [weak self] () in
            guard let s = self else { return }
            s.favoritesTableView.reloadData()
        }
        self.visitsConfig.updateVisitsList { [weak self] () in
            guard let s = self else { return }
            s.visitsTableView.reloadData()
        }
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case RestaurantListType.favorites.hashValue:
            if (self.listType == .favorites) { return }
            self.view.addSubview(self.favoritesTableView)
            self.currentTableView(self.listType).removeFromSuperview()
            self.listType = .favorites
        case RestaurantListType.visits.hashValue:
            if (self.listType == .visits) { return }
            self.view.addSubview(self.visitsTableView)
            self.currentTableView(self.listType).removeFromSuperview()
            self.listType = .visits
        default:
            return
        }
        self.currentTableView(self.listType).snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        self.currentTableView(self.listType).reloadData()
    }
    
    fileprivate func currentTableView(_ type: RestaurantListType) -> UITableView {
        switch type {
        case .favorites:
            return self.favoritesTableView
        case .visits:
            return self.visitsTableView
        default:
            fatalError()
        }
    }
    
}

// MARK: - UITableViewDelegate Methods
extension FavoritesAndVisitsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.currentTableView(self.listType).cellForRow(at: indexPath) as! RestaurantListCell
        let restaurant = cell.restaurant
        let detailVC = DetailViewController(restaurant: restaurant)
        detailVC.navigationItem.title = restaurant.shopName
        print("id: \(restaurant.shopID)")
        let backButtonItem = UIBarButtonItem(title: NSLocalizedString("Back", comment: ""), style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButtonItem
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
}
