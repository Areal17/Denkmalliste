//
//  CLLocationCoordinate2D+Extensions.swift
//  Denkmalliste
//
//  Extracted from MapView.swift
//

import CoreLocation

extension CLLocationCoordinate2D {
    /// Check if two coordinates are equal
    static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.longitude == right.longitude && left.latitude == right.latitude
    }

    /// Check if two coordinates are not equal
    static func != (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.longitude != right.longitude || left.latitude != right.latitude
    }

    /// Check if the distance to another location is greater than a sufficient value
    /// - Parameters:
    ///   - otherLocation: The location to compare to
    ///   - sufficientValue: The minimum distance in meters
    /// - Returns: True if the distance exceeds the sufficient value
    func sufficientDistance(to otherLocation: CLLocationCoordinate2D, sufficientValue: Double) -> Bool {
        let location = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let newLocation = CLLocation(latitude: otherLocation.latitude, longitude: otherLocation.longitude)
        return location.distance(from: newLocation) > sufficientValue as CLLocationDistance ? true : false
    }
}
