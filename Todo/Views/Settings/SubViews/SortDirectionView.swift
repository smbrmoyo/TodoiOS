//
//  SortDirectionView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct SortDirectionView: View {
    @Binding var sortDirection: SortDirection
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Sort Date Direction")
                
                RadioButton(tag: SortDirection.ascending,
                            selection: $sortDirection,
                            label: SortDirection.ascending.rawValue.capitalized)
                
                RadioButton(tag: SortDirection.descending,
                            selection: $sortDirection,
                            label: SortDirection.descending.rawValue.capitalized)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SortDirectionView(sortDirection: .constant(.ascending))
}
