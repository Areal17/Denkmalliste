//
//  ContentView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 29.11.21.
//

import SwiftUI
import CoreLocation
import MapKit



struct ContentView: View {
    @State private var locations = CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889)
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889), latitudinalMeters: 750, longitudinalMeters: 750)
    @ObservedObject var locationParser = LocationParser(contentsOf: Bundle.main.url(forResource: "baudenkmal", withExtension: "kml")!)!
    @State var monuments = [Int: Monument]()
    @State var showDetail = false
    var body: some View {
        NavigationView {
            VStack {
                Text("Denkmale in Berlin").font(.title).background(
                    RoundedRectangle(cornerRadius: 6.0)
                        .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                        .frame(width: 280, height: 44, alignment: .center)
                    .shadow(color: Color.gray, radius: 6.0, x: 1.5, y: 1.5)
                )
                    .padding(.vertical)
                MapView(centerCoordinates: $locations, currentLocation: $locations, region: $region,monuments: $monuments, showDetail: $showDetail, placemarks: locationParser.parsedPlacemarks).modifier(RoundedRectView()).padding(.horizontal)
                Text("Hallo Denkmale in Berlin!")
                    .padding()
            }
            .background(Color(.sRGB, red: (232.0 / 255.0), green: (232.0 / 255.0), blue: (232.0 / 255.0), opacity: 1.0))
            .navigationBarHidden(true)
            .task {
                if let csvFileURL =  Bundle.main.url(forResource: "denkmalliste_berlin", withExtension: "csv") {
                    do {
                        monuments = try await CSVParser().parseCSVFile(fileURL:csvFileURL, lineSeperator: ControlCharacter.windowsLineFeed)
                    } catch {
                        print(error)
                    }
                }
            }
            if showDetail == true {
                NavigationLink(destination: Text("Details hier")) { }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//
