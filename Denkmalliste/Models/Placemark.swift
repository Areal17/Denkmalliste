//
//  Placemark.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 02.12.21.
//  Refactored: Extracted from LocationParser.swift
//

import Foundation
import CoreLocation

/// Represents a geographic location marker for a monument
struct Placemark {
    var name: String
    var coordinates: [CLLocationCoordinate2D]

    init() {
        self.name = "k.A"
        self.coordinates = [CLLocationCoordinate2D]()
    }
}
