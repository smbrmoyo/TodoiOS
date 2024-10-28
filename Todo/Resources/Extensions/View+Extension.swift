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
}
