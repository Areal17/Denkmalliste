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
    private static let fileURLs = [Bundle.main.url(forResource: "baudenkmal", withExtension: "kml")!,Bundle.main.url(forResource: "gartendenkmal", withExtension: "kml")!]
    @ObservedObject var locationParser = LocationParser(contentsOf: fileURLs)!
    @State var monuments = [Int: Monument]()
    @State var showDetail = false
    @State var currentMonument: Monument?
    var body: some View {
        NavigationView {
            
            VStack {
                Text("Denkmale in Berlin").font(.title).background(
                    RoundedRectangle(cornerRadius: 6.0)
                        .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                        .frame(width: 280, height: 44, alignment: .center)
                        .modifier(monumentBackgroundShadow())
                )
                    .padding(.vertical)
                MapView(centerCoordinates: $locations,
                        currentLocation: $locations,
                        region: $region,
                        monuments: $monuments,
                        currentMonument: $currentMonument,
                        showDetail: $showDetail,
                        placemarks: locationParser.parsedPlacemarksDict)
                            .modifier(RoundedRectView()).padding(.horizontal)
                NavigationLink(destination: MonumentDetailView(monument: currentMonument), isActive: $showDetail) { }
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
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//
