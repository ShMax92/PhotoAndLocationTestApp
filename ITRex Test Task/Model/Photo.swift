//
//  Photo.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 30.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import UIKit
import CoreLocation

struct Photo: Codable {

    let photoData: Data?
    let photoDate: Date
    let photoLocation: Location?
    
    init(photoData: Data, photoDate: Date, photoLocation: Location) {
        self.photoData = photoData
        self.photoDate = photoDate
        self.photoLocation = photoLocation
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
