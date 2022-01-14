//
//  Styles.swift
//  Example
//
//  Copyright © 2022 Jedlix. All rights reserved.
//

import SwiftUI

struct Styles {
    static let elementHeight: CGFloat = 50
    static let cornerRadius: CGFloat = elementHeight / 2
}

struct ExampleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .autocapitalization(.none)
            .padding()
            .frame(height: Styles.elementHeight)
            .background(Color.secondary.opacity(0.3))
            .cornerRadius(Styles.cornerRadius)
    }
}

struct ExampleButtonStyle: ButtonStyle {
    private let backgroundColor: Color
    
    init(_ backgroundColor: Color = .accentColor) {
        self.backgroundColor = backgroundColor
    }
    
    func makeBody(configuration: ButtonStyleConfiguration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: Styles.elementHeight)
            .foregroundColor(.white)
            .background(backgroundColor)
            .cornerRadius(Styles.cornerRadius)
    }
}
