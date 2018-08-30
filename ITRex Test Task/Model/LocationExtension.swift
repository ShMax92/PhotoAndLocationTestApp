//
//  LocationExtension.swift
//  ITRex Test Task
//
//  Created by Maxim Shirko on 30.08.2018.
//  Copyright © 2018 com.MaximShirko. All rights reserved.
//

import CoreLocation

extension CLLocation: Encodable {
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}
