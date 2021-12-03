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

struct MapView: UIViewRepresentable {
    
    @Binding var centerCoordinates: CLLocationCoordinate2D
    @Binding var currentLocation: CLLocationCoordinate2D
    @Binding var region: MKCoordinateRegion
    
    typealias UIViewType = MKMapView
    func makeUIView(context: Context) -> MKMapView {
        let uiMapView = MKMapView()
        uiMapView.delegate = context.coordinator
        uiMapView.isZoomEnabled = true
        uiMapView.showsUserLocation = true
        uiMapView.showsCompass = true
        uiMapView.setRegion(region, animated: false)
        let locationManager = CLLocationManager()
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        if let kmlURL = Bundle.main.url(forResource: "baudenkmal", withExtension: "kml") {
            let kmlParser = LocationParser(contentsOf: kmlURL)
        }
        
        return uiMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //doso
        uiView.setCenter(currentLocation, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

}


class Coordinator: NSObject, MKMapViewDelegate{
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        parent.centerCoordinates = mapView.userLocation.coordinate
        parent.currentLocation = mapView.userLocation.coordinate
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        print("\(mapView) did stop locate user")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        parent.currentLocation = userLocation.coordinate
        parent.centerCoordinates = userLocation.coordinate
    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print(error)
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print(mode)
    }
}


#if DEBUG
struct MapView_Previews: PreviewProvider {
    // In _Previews muss die State-Property static sein
    @State static var testLocation = CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889)
    @State static var testRegioin = MKCoordinateRegion(center: testLocation, latitudinalMeters: 750, longitudinalMeters: 750)
    static var previews: some View {
        MapView(centerCoordinates: $testLocation, currentLocation: $testLocation, region: $testRegioin)
    }
}
#endif
