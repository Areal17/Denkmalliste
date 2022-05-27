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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.631389, longitude: 8.073889), latitudinalMeters: 750, longitudinalMeters: 750)
    private static let fileNames = ["baudenkmal", "gartendenkmal"]
    @ObservedObject var locationParser = LocationParser(contentsOf: fileNames)!
    @ObservedObject var geocoding = Geocoding()
    @State var monuments = [Int: Monument]()
    @State var showDetail = false
    @State var currentMonument: Monument?
    @State var monumentID: Int?
    @State var currentLocation = CLLocationCoordinate2D()
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
                MapView(currentLocation: $currentLocation,
                        region: $region,
                        monuments: $monuments,
                        currentMonument: $currentMonument,
                        monumentID: $monumentID,
                        showDetail: $showDetail,
                        placemarks: locationParser.parsedPlacemarksDict)
                            .modifier(RoundedRectView()).padding(.horizontal)
                NavigationLink(destination: MonumentDetailView(monument: currentMonument, placemark: locationParser.parsedPlacemarksDict[monumentID ?? 0]), isActive: $showDetail) { }
                Text(verbatim: geocoding.userPlacemark?.thoroughfare as String? ?? "Hallo Denkmale in Berlin!")
///                thoroughfare = Straßenname; subThoroughfare = Hausnummer
                    .padding()
            }
            .background(Color(.sRGB, red: (232.0 / 255.0), green: (232.0 / 255.0), blue: (232.0 / 255.0), opacity: 1.0))
            .navigationBarHidden(true)
            .task {
                geocoding.addressFromLocation(currentLocation)
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
