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
    
    init() {
        self.addressFromLocation(CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889))
    }
    
    func addressFromLocation(_ location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        geocoder.reverseGeocodeLocation(location) { locationPlacemarks, locationError in
            if locationError != nil {
                print(locationError!.localizedDescription)
            }
            if let locationPlacemarks = locationPlacemarks {
                print(locationPlacemarks.first)
                self.userPlacemark = locationPlacemarks.first
            }
        }
    }
    
}
