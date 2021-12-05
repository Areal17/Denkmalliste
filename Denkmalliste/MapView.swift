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
    var placemarks: [Placemark]
    typealias UIViewType = MKMapView
    // MapView(centerCoordinates: $testLocation, currentLocation: $testLocation, region: $testRegion)
    
//    init(centerCoordinates: Binding<CLLocationCoordinate2D>, currentLocation: Binding<CLLocationCoordinate2D>, region: Binding<MKCoordinateRegion>, placemarks: [Placemark]) {
//        merkwürdig aber wohl notwendig. Der Unterstrich vor den Binding Variablen.
//        self._centerCoordinates = centerCoordinates
//        self._currentLocation = currentLocation
//        self._region = region
//        self.placemarks = placemarks
//    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        let uiMapView = MKMapView()
        uiMapView.delegate = context.coordinator
        uiMapView.isZoomEnabled = true
        uiMapView.showsUserLocation = true
        uiMapView.showsCompass = true
        uiMapView.setRegion(region, animated: false)
//        if let kmlURL = Bundle.main.url(forResource: "baudenkmal", withExtension: "kml") {
//            let kmlParser = LocationParser(contentsOf: kmlURL)
//            kmlParser?.parseDocument()
//        }
        
        return uiMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if let newCurrentLocation = placemarks.first?.coordinates {
            print(newCurrentLocation)
            uiView.setCenter(newCurrentLocation, animated: false)
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func getCurrentAnnotations(forPlacemarks: [Placemark]) -> [MKPointAnnotation] {
        var pointAnnotations = [MKPointAnnotation]()
        for placemark in forPlacemarks {
            let pointAnnotation = MKPointAnnotation()
            pointAnnotation.coordinate = placemark.coordinates!
            pointAnnotations.append(pointAnnotation)
        }
        return pointAnnotations
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
        print("MapView did fail loading with error: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print(mode)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKAnnotationView()
    }
}


#if DEBUG
struct MapView_Previews: PreviewProvider {
    // In _Previews muss die State-Property static sein
    @State static var testLocation = CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889)
    @State static var testRegion = MKCoordinateRegion(center: testLocation, latitudinalMeters: 750, longitudinalMeters: 750)
    static var placemarks = [Placemark]()
    static var previews: some View {
        MapView(centerCoordinates: $testLocation, currentLocation: $testLocation, region: $testRegion, placemarks: placemarks)
    }
}
#endif
