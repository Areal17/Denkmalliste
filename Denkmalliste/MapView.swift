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
    
    
    func makeUIView(context: Context) -> MKMapView {
        let uiMapView = MKMapView()
        uiMapView.delegate = context.coordinator
        uiMapView.isZoomEnabled = true
        uiMapView.showsUserLocation = true
        uiMapView.showsCompass = true
        uiMapView.setRegion(region, animated: false)
        
        return uiMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        #if targetEnvironment(simulator)
            if let newCurrentLocation = placemarks.first?.coordinates {
                uiView.setCenter(newCurrentLocation, animated: false)
                _ = getCurrentAnnotations(forPlacemarks: placemarks, at: newCurrentLocation)
                let userLocation = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                let firstPlacemarkLocation = CLLocation(latitude: newCurrentLocation.latitude, longitude: newCurrentLocation.longitude)
                let distance = userLocation.distance(from: firstPlacemarkLocation)
                print("Der User ist: \(distance / 1000) km entfernt")
//                Zwei Werte werden ausgegeben: Fautenbach und London
                let nearbyAnnotations = getCurrentAnnotations(forPlacemarks: placemarks, at: newCurrentLocation)
                uiView.addAnnotations(nearbyAnnotations)
            }
        #else
        uiView.setCenter(currentLocation, animated: false)
        let nearbyAnnotations = getCurrentAnnotations(forPlacemarks: placemarks, at: currentLocation)
        uiView.addAnnotations(nearbyAnnotations)
        #endif
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func getCurrentAnnotations(forPlacemarks: [Placemark], at location: CLLocationCoordinate2D ) -> [MKPointAnnotation] {
        var pointAnnotations = [MKPointAnnotation]()
        let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        for placemark in forPlacemarks {
            let placemarkCoordinate = CLLocation(latitude: placemark.coordinates!.latitude, longitude: placemark.coordinates!.longitude)
            let distanceToUserlocation = placemarkCoordinate.distance(from: userLocation)
//            print(distanceToUserlocation)
            if distanceToUserlocation <= 7500 { // der Wert muss dynamisch sein und sich auf die Region beziehen, die angezeigt wird
                let pointAnnotation = MKPointAnnotation()
                pointAnnotation.title = placemark.name
                pointAnnotation.coordinate = placemark.coordinates!
                pointAnnotations.append(pointAnnotation)
            }
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
        //print("\(mapView) did stop locate user")
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
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = DenkmalAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
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
