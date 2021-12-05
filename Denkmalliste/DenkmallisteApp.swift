//
//  DenkmallisteApp.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 29.11.21.
//

import SwiftUI
import CoreLocation

@main
struct DenkmallisteApp: App {
    
    init() {
        askForPermission()
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("placemarkNotification"), object: nil, queue: OperationQueue.current) { placmarksNotification in
//            let postedPlacmarks = placmarksNotification.userInfo?["placemarks"]
//        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func askForPermission() {
        let locationManager = CLLocationManager()
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
}
