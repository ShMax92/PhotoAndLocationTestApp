//
//  Permissions.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 28.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import CoreLocation

class Permissions: NSObject {

    var locationPermissionEnabled = false
    private let locationManager = CLLocationManager()
    
    func enableLocatonServices(){
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            locationPermissionEnabled = false
            break
            
        case .authorizedWhenInUse:
            locationPermissionEnabled = true
            break
            
        case .authorizedAlways:
            locationPermissionEnabled = true
            break
        }
    }
    
}
