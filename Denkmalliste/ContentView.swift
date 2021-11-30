//
//  ContentView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 29.11.21.
//

import SwiftUI



struct ContentView: View {
    var body: some View {
        
        VStack {
            Text("Denkmale in Berlin").font(.title).background(
                RoundedRectangle(cornerRadius: 6.0)
                    .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                    .frame(width: 280, height: 44, alignment: .center)
                .shadow(color: Color.gray, radius: 6.0, x: 1.5, y: 1.5)
            )
                .padding(.vertical)
            MapView().modifier(RoundedRectView()).padding(.horizontal)
            Text("Hallo Denkmale in Berlin!")
                .padding()
        }
        .background(Color(.sRGB, red: (232.0 / 255.0), green: (232.0 / 255.0), blue: (232.0 / 255.0), opacity: 1.0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
