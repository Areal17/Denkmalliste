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
                .fill(Color.white)
                    .frame(width: 280, height: 44, alignment: .center)
                .shadow(color: Color.gray, radius: 6.0, x: 1.5, y: 1.5)
            )
                .padding(.bottom)
            MapView().modifier(RoundedRectView())
            Text("Hallo Denkmale in Berlin!")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
