//
//  MonumentDetailView.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 07.01.22.
//

import SwiftUI

struct MonumentDetailView: View {
    var monument: Monument?
    var body: some View {
        VStack {
            Text("Details").font(.title).background(
                RoundedRectangle(cornerRadius: 6.0)
                    .fill(Color(.sRGB, red: (243.0 / 255.0), green: (243.0 / 255.0), blue: (243.0 / 255.0), opacity: 1.0))
                    .frame(width: 280, height: 44, alignment: .center)
                .shadow(color: Color.gray, radius: 6.0, x: 1.5, y: 1.5)
            )
//                .padding(.vertical)
            if monument != nil {
                VStack{
                    Text(monument!.address)
                        .padding(.top)
                    Text(monument!.monumentDescription)
                        .padding(.vertical)
                    Text("Archiktekt: \(monument!.architect)")
                        .padding(.vertical)
                        .font(.footnote)
                    Spacer()
                }
            }
        }
            
    }
}

struct MonumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MonumentDetailView()
    }
}
