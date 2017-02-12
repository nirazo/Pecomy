//
//  DebugMapViewController.swift
//  Pecomy
//
//  Created by Kenzo on 1/29/17.
//  Copyright © 2017 Pecomy. All rights reserved.
//

import UIKit
import MapKit

class DebugMapViewController: UIViewController {

    let mapView = MKMapView()
    let annotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let location = CLLocationCoordinate2D(latitude: CLLocationDegrees(Const.fixedLatitude), longitude: CLLocationDegrees(Const.fixedLongitude))
        self.mapView.setCenter(location, animated: true)
        
        var region = self.mapView.region
        region.center = location
        region.span.latitudeDelta = 0.01
        region.span.longitudeDelta = 0.01
        self.mapView.setRegion(region, animated: true)
        mapView.mapType = MKMapType.standard
        self.view.addSubview(mapView)
        mapView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
        
        // 長押しgestureRecognizer追加
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(sender:)))
        self.mapView.addGestureRecognizer(gesture)
        
        // ピン
        self.annotation.title = R.string.localizable.currentDebugLocation()
        self.annotation.coordinate = CLLocationCoordinate2DMake(Const.fixedLatitude, Const.fixedLongitude)
        self.annotation.subtitle = "\(self.annotation.coordinate.latitude), \(self.annotation.coordinate.longitude)"
        self.mapView.addAnnotation(self.annotation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func longPress(sender: UILongPressGestureRecognizer) {
        if (sender.state == .began){
            let location = sender.location(in: self.mapView)
            let mapPoint = self.mapView.convert(location, toCoordinateFrom: self.mapView)
            
            //ピンの座標変更
            self.annotation.coordinate = CLLocationCoordinate2DMake(mapPoint.latitude, mapPoint.longitude)
            self.annotation.subtitle = "\(self.annotation.coordinate.latitude), \(self.annotation.coordinate.longitude)"
            Const.fixedLatitude = mapPoint.latitude
            Const.fixedLongitude = mapPoint.longitude
        }
    }
}

extension DebugMapViewController: MKMapViewDelegate {
    
}
