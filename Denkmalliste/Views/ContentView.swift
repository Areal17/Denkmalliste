//
//  ContentView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 29.11.21.
//  Refactored: Moved business logic to ContentViewModel
//

import SwiftUI
import CoreLocation
import MapKit

/// Main view containing the map and monument information
/// Now uses MVVM pattern with ContentViewModel
struct ContentView: View {

    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                MapView(
                    region: $viewModel.region,
                    monuments: $viewModel.monuments,
                    currentMonument: $viewModel.currentMonument,
                    monumentID: $viewModel.monumentID,
                    showDetail: $viewModel.showDetail,
                    placemarks: viewModel.placemarks
                )
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // Title
                    Text("Denkmale in Berlin")
                        .font(.title)
                        .background(
                            RoundedRectangle(cornerRadius: 6.0)
                                .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                                .frame(width: 280, height: 44, alignment: .center)
                                .modifier(monumentBackgroundShadow())
                        )
                        .padding(.vertical)

                    Spacer()

                    // Current location address (thoroughfare = Straßenname; subThoroughfare = Hausnummer)
                    Text(verbatim: viewModel.currentAddress)
                        .padding(.horizontal)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 6.0, style: .continuous))
                        .modifier(monumentBackgroundShadow())
                        .padding()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $viewModel.showDetail) {
                MonumentDetailView(
                    monument: viewModel.currentMonument,
                    placemark: viewModel.placemark(for: viewModel.monumentID)
                )
            }
            .task {
                await viewModel.loadData()
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
