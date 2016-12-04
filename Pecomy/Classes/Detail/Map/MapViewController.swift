//
//  MapViewController.swift
//  Pecomy
//
//  Created by Kenzo on 2016/01/26.
//  Copyright © 2016 Pecomy. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    
    var restaurant: Restaurant?
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapView = GMSMapView(frame: .zero)
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        
        guard let restaurant = self.restaurant else {
            return
        }
        // 地図
        let lat = Double(restaurant.latitude)
        let lon = Double(restaurant.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: lat,longitude: lon, zoom: 17)
        mapView.camera = camera
        mapView.isMyLocationEnabled = true
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(lat, lon)
        marker.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
