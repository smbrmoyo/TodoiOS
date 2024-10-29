//
//  TodoLoadingView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct TodoLoadingView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.background)
            
            HStack {
                ShimmeringView(width: 80, height: 80, cornerRadius: 10)
                
                VStack(alignment: .leading) {
                    ShimmeringView(height: 20, cornerRadius: 5)
                    
                    ShimmeringView(height: 15, cornerRadius: 5)
                }
                .padding(.trailing)
                
                Spacer()
                
                ShimmeringView(width: 80, height: 20, cornerRadius: 5)
                
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 100)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
    }
}


#Preview {
    TodoLoadingView()
}
