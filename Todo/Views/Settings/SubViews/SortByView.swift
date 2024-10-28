//
//  SortByView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct SortByView: View {
    @Binding var sortBy: SortBy
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Sort By")
                
                RadioButton(tag: SortBy.due,
                            selection: $sortBy,
                            label: SortBy.due.rawValue.capitalized)
                
                RadioButton(tag: SortBy.created,
                            selection: $sortBy,
                            label: SortBy.created.rawValue.capitalized)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SortByView(sortBy: .constant(.due))
}
