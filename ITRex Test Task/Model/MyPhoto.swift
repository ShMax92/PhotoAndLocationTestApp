//
//  MyPhoto.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 30.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import CoreLocation

struct MyPhoto: Codable {

    let photo: Data
    let date: Date
    let location: Location
    
    init(photo: Data, date: Date, location: Location) {
        self.photo = photo
        self.date = date
        self.location = location
    }
}

struct Location: Codable {
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

extension CLLocation {
    convenience init(model: Location) {
        self.init(latitude: model.latitude, longitude: model.longitude)
    }
}
