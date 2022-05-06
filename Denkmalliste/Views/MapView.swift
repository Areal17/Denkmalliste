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


extension CLLocationCoordinate2D {
    static func == (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.longitude == right.longitude && left.latitude == right.latitude
    }
    
    static func != (left: CLLocationCoordinate2D, right: CLLocationCoordinate2D) -> Bool {
        return left.longitude != right.longitude || left.latitude != right.latitude
    }
    
}


struct MapView: UIViewRepresentable {
    
//    Anderen Ort wählen.
    @State var centerCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889)
    @State var currentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889)
    @Binding var region: MKCoordinateRegion
    @Binding var monuments: [Int: Monument]
    @Binding var currentMonument: Monument?
    @Binding var monumentID: Int?
    @Binding var showDetail: Bool
    var placemarks: [Int: Placemark]
    var locationManager = CLLocationManager()
    typealias UIViewType = MKMapView
    let uiMapView = MKMapView()
    
    func makeUIView(context: Context) -> MKMapView {
        //let uiMapView = MKMapView()
        uiMapView.delegate = context.coordinator
        if locationManager.authorizationStatus == .notDetermined {
            print("Status noch nicht abgefragt")
        }
        locationManager.delegate = context.coordinator
        locationManager.startUpdatingLocation()
        uiMapView.isZoomEnabled = true
        uiMapView.showsCompass = true
        uiMapView.setRegion(region, animated: false)
        uiMapView.register(MonumentAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        uiMapView.register(ClusterMonumentAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultClusterAnnotationViewReuseIdentifier)
                #if targetEnvironment(simulator)
                    let newCurrentLocation = placemarks.values.first!.coordinates.first!
                    uiMapView.setCenter(newCurrentLocation, animated: false)
                    let nearbyAnnotations = currentAnnotations(forPlacemark: Array(placemarks.values), at: newCurrentLocation)
                    uiMapView.addAnnotations(nearbyAnnotations)
                #else
//                uiMapView.setCenter(currentLocation, animated: false)
                let nearbyAnnotations = currentAnnotations(forPlacemark: Array(placemarks.values), at: currentLocation)
                uiMapView.addAnnotations(nearbyAnnotations)
                #endif
        return uiMapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.setCenter(currentLocation, animated: false)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func currentAnnotations(forPlacemark placemarks: [Placemark], at location: CLLocationCoordinate2D ) -> [MKPointAnnotation] {
        var pointAnnotations = [MonumentPointAnnotation]()
        //let userLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        for placemark in placemarks {
            if let objectID = Int(placemark.name) {
                let currentMonument = monuments[objectID]
                for coordinate in placemark.coordinates {
                    let pointAnnotation = MonumentPointAnnotation(objectID: objectID)
                    if currentMonument?.kindOfMonument == "Gartendekmal" || currentMonument?.kindOfMonument == "Gartendenkmal" { //Tippfehler in der kml Datei!
                        pointAnnotation.kindOfMonument = .garden
                    } else if currentMonument?.kindOfMonument == "Baudenkmal" {
                        pointAnnotation.kindOfMonument = .building
                    }
                    pointAnnotation.title = currentMonument?.address
                    pointAnnotation.coordinate = coordinate
                    pointAnnotations.append(pointAnnotation)
                }
            }
        }
        return pointAnnotations
    }

}


class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    var parent: MapView
    
    init(_ parent: MapView) {
        self.parent = parent
    }
    
    
    //MARK: MapViewDelegate
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        parent.centerCoordinates = mapView.userLocation.coordinate
        parent.currentLocation = mapView.userLocation.coordinate
    }
    
    func mapViewDidStopLocatingUser(_ mapView: MKMapView) {
        //print("\(mapView) did stop locate user")
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        #if targetEnvironment(simulator)
            print("Did update Userlocation")
        #else
        guard parent.currentLocation != userLocation.coordinate else { return }
        parent.currentLocation = userLocation.coordinate
        parent.centerCoordinates = userLocation.coordinate
        #endif
    }
    
    func mapViewWillStartLocatingUser(_ mapView: MKMapView) {
        #if targetEnvironment(simulator)
        print("will start userlocation")
        mapView.showsUserLocation = true
        #endif
    }
    
//    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//        print("Did change locatingUser\(mapView.userLocation.coordinate)")
//    }
    
    func mapViewDidFailLoadingMap(_ mapView: MKMapView, withError error: Error) {
        print("MapView did fail loading with error: \(error)")
    }
    
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        print(mode)
    }
    
    
    func mapView(_ mapView: MKMapView, didFailToLocateUserWithError error: Error) {
        print("UserLocationError: \(error)")
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let tappedButton = control as! UIButton
        if tappedButton.isTouchInside {
            parent.showDetail = true
        }
    }
    
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation.isKind(of: MonumentPointAnnotation.self) {
//            var annotationView = MonumentAnnotationView(annotation: annotation, reuseIdentifier: MonumentAnnotationView.ReuseID)
//            annotationView.canShowCallout = true
//            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//            return annotationView
//        }
//        return nil
//    }
//    
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isKind(of: MonumentAnnotationView.self) == true {
            let monumentAnnotation = view.annotation as! MonumentPointAnnotation
            let monumentID = monumentAnnotation.objectID
            parent.currentMonument = parent.monuments[monumentID]
            parent.monumentID = monumentID
//            Title wird hier gesetzt, da in makeUIView die Adresse noch nil ist. (da asynchron)
            monumentAnnotation.title = parent.currentMonument?.address
        }
    }
    
    //    mark: CLLocationManager
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("Did update Locations")
            //TODO: ggf noch vorherige Postion speichern und mit neuer vergleichen. Wenn sich die Postion nicht signifikant geändert hat, dann Center nicht neu setzen
            if let location = locations.first {
                parent.uiMapView.setCenter(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), animated: false)
                parent.uiMapView.showsUserLocation = true
            }
        }
    
}


#if DEBUG
struct MapView_Previews: PreviewProvider {
    // In _Previews muss die State-Property static sein
    @State static var testLocation = CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889)
    @State static var testRegion = MKCoordinateRegion(center: testLocation, latitudinalMeters: 750, longitudinalMeters: 750)
    @State static var testMonuments = [Int: Monument]()
    @State static var showDetail = false
    @State static var testMonument: Monument?
    @State static var testID: Int?
    static var placemarks = [Int:Placemark]()
    static var previews: some View {
        MapView(region: $testRegion,monuments: $testMonuments,currentMonument: $testMonument,monumentID: $testID, showDetail: $showDetail, placemarks: placemarks)
    }
}
#endif
