//
//  MonumentDetailView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 07.01.22.
//

import SwiftUI
import MapKit

struct MonumentAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MonumentDetailView: View {
    var monument: Monument?
    var placemark: Placemark?
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
    @State var monumentLocation: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var body: some View {
        VStack {
            Text("Details")
                .font(.title)
                .background(
                RoundedRectangle(cornerRadius: 6.0)
                    .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                    .frame(width: 280, height: 44, alignment: .center)
//                    .padding()
                    .modifier(monumentBackgroundShadow())
            )
              //  .padding(.vertical)
            if monument != nil {
                VStack{
                    if monument!.objectDocNr != nil {
                        Map(coordinateRegion: $coordinateRegion, annotationItems: [MonumentAnnotation(coordinate: monumentLocation)]) {_ in
                            MapAnnotation(coordinate: monumentLocation) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 16, height: 16, alignment: .center)
                                    .overlay {
                                        Circle()
                                            .stroke(Color.white,style: StrokeStyle(lineWidth: 3.0))
                                    }
                            }
                        }
                            .padding()
                            .modifier(monumentBackgroundShadow())
                    }
                        Text(monument!.address)
                        Text(monument!.monumentDescription)
                            .padding(.vertical)
                        Text(monument!.kindOfMonument)
                            .padding(.vertical)
                        Text("Architekt: \(monument!.architect)")
                            .padding(.vertical)
                        Spacer()
                }
                .background(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 6.0))
                .modifier(monumentBackgroundShadow())
                .padding()
            }
            if monument!.locality.isEmpty == false || monument?.locality != "NA" {
                Text(monument!.locality)
                    .padding(.bottom)
                    .tint(.gray)
            }
        }
        .onAppear {
            if let currentPlacemark = placemark {
                coordinateRegion = MKCoordinateRegion(center: currentPlacemark.coordinates.first!, latitudinalMeters: 450, longitudinalMeters: 450)
                monumentLocation = currentPlacemark.coordinates.first!
            }
        }
    }
}

struct MonumentDetailView_Previews: PreviewProvider {
    static var placemark  = Placemark()
    static var previews: some View {
        MonumentDetailView(placemark: placemark)
    }
}
