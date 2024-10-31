//
//  LimitView.swift
//  Todo
//
//  Created by Brian Moyou on 31.10.24.
//

import SwiftUI

struct LimitView: View {
    @Binding var selectedLimit: FetchTodosLimit
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Limit")
                    .font(.title)
                
                RadioButton(tag: FetchTodosLimit.ten,
                            selection: $selectedLimit,
                            label: String(FetchTodosLimit.ten.rawValue))
                
                RadioButton(tag: FetchTodosLimit.twenty,
                            selection: $selectedLimit,
                            label: String(FetchTodosLimit.twenty.rawValue))
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    LimitView(selectedLimit: .constant(.ten))
}
