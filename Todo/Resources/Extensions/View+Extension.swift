//
//  View+Extension.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

extension View {
    func elevation() -> some View {
        self.shadow(color: .gray, radius: 4, x: 2, y: 2)
    }
    
    func customTextField(title: String) -> some View {
        self.modifier(TextFieldModifier(title: title))
    }
    
    func working(uiState: UIState) -> some View {
        ZStack {
            self
            
            if uiState == .working {
                Color.white.opacity(0.5)
                
                ProgressView()
            }
        }
        .disabled(uiState == .working)
    }
}
