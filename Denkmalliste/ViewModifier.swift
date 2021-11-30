//
//  ViewModifier.swift.swift
//  Denkmalliste
//
//  Created by Ingo Wiederoder on 30.11.21.
//

import SwiftUI


struct RoundedRectView: ViewModifier {
    let radius: CGFloat = 8.0
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: radius))
            .shadow(color: Color.gray, radius: radius, x: 2.3, y: 2.3)
            .padding(.horizontal, 4.0)
    }
}
