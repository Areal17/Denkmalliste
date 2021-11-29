//
//  MapView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 29.11.21.
//

import SwiftUI
import UIKit
import MapKit
import CoreLocation

struct MapView: View {
    
    @State private var userRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(), latitudinalMeters: 750, longitudinalMeters: 750)
    @State private var userTrackingMode = MKUserTrackingMode.follow
    @State private var allInteractionMode = MapInteractionModes.all
    
    var body: some View {
        Map(coordinateRegion: $userRegion)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
