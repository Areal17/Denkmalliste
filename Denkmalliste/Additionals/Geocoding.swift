//
//  Geocoding.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 20.02.22.
//

import Foundation
import CoreLocation


class Geocoding: ObservableObject {

    @Published var userPlacemark: CLPlacemark?
    
    var userLocation: CLLocationCoordinate2D

    init() {
        self.userLocation = CLLocationCoordinate2D()
    }
    
    /// Take the location of the user and get the placemarks for the location: 
    /// - Parameter location: the user location as CLLocationCoordinate2D
    func addressFromLocation(_ location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeLocation(location) { locationPlacemarks, locationError in
            if locationError != nil {
                print(locationError!.localizedDescription)
            }
            if let locationPlacemarks = locationPlacemarks {
                self.userPlacemark = locationPlacemarks.first
            }
        }
    }
    
}
