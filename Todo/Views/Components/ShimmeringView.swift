//
//  ShimmeringView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct ShimmeringView: View {
    @State private var isInitialState = true
    var width: CGFloat = .infinity
    var height: CGFloat
    var cornerRadius: CGFloat
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.white.opacity(0.3))
                .frame(height: height)
                .frame(maxWidth: width)
            
            LinearGradient(gradient: Gradient(colors: [.white.opacity(0.2), .white.opacity(0.5), .clear]),
                           startPoint: (isInitialState ? .init(x: -0.1, y: 0) : .init(x: 1, y: 1)),
                           endPoint: (isInitialState ? .init(x: 0, y: 0) : .init(x: 1, y: 1)))
            .animation(.linear(duration: 1).delay(0.1).repeatForever(autoreverses: false), value: isInitialState)
            .onAppear {
                isInitialState = false
            }
            .frame(height: height)
            .frame(maxWidth: width)
        }
    }
}

#Preview {
    ShimmeringView(width: 80, height: 80, cornerRadius: 5)
}
