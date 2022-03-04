//
//  ViewModifier.swift.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 30.11.21.
//

import SwiftUI


struct RoundedRectView: ViewModifier {
    let radius: CGFloat = 6.0
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: Color.gray, radius: radius / 2, x: 1.0, y: 1.0)
    }
}


struct monumentBackgroundShadow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.gray, radius: 3.0, x: 1.0, y: 1.0)
    }
}
