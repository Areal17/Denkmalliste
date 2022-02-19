//
//  MonumentDetailView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 07.01.22.
//

import SwiftUI
import MapKit

struct MonumentDetailView: View {
    var monument: Monument?
    var placemark: Placemark?
    @State var coordinateRegion: MKCoordinateRegion = MKCoordinateRegion()
    var body: some View {
        VStack {
            Text("Details")
                .font(.title)
                .background(
                RoundedRectangle(cornerRadius: 6.0)
                    .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                    .frame(width: 280, height: 44, alignment: .center)
                    .modifier(monumentBackgroundShadow())
            )
                .padding(.vertical)
            if monument != nil {
                VStack{
                    if monument!.objectDocNr != nil {
                        Map(coordinateRegion: $coordinateRegion)
                            .modifier(monumentBackgroundShadow())
                    }
                        Text(monument!.address)
                            .padding(.vertical)
                        Text(monument!.monumentDescription)
                            .padding(.vertical)
                        Text(monument!.kindOfMonument)
                            .padding(.vertical)
                        Text("Architekt: \(monument!.architect)")
                            .padding(.vertical)
                            .font(.footnote)
                        Spacer()
                }
                .background(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                //.frame(width: .infinity, alignment: .center)
                .clipShape(RoundedRectangle(cornerRadius: 6.0))
                .modifier(monumentBackgroundShadow())
                .padding(.bottom)
            }
        }
        .onAppear {
            if let currentPlacemark = placemark {
                coordinateRegion = MKCoordinateRegion(center: currentPlacemark.coordinates.first!, latitudinalMeters: 450, longitudinalMeters: 450)
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
