//
//  MapVC.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 31.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import MapKit

fileprivate let radius = 5000.0

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var myPhoto: MyPhoto? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myPhoto = myPhoto {
            let latitude = myPhoto.location.latitude
            let longitude = myPhoto.location.longitude
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, radius, radius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        

        
    }
}
