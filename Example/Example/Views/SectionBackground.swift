//
//  SectionBackground.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI

struct SectionBackground: ViewModifier {
    
    func body(content: Content) -> some View {
        HStack {
            content
            Spacer(minLength: 0)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(UIColor.systemGray5))
        .cornerRadius(16)
    }
}

extension View {
    func sectionBackground() -> some View {
        modifier(SectionBackground())
    }
}
