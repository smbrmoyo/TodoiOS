//
//  FiltersView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct FiltersView: View {
    @Binding var selectedFilter: QueryFilter
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Filters")
                    .font(.title)
                
                RadioButton(tag: QueryFilter.all,
                            selection: $selectedFilter,
                            label: QueryFilter.all.rawValue.capitalized)
                
                RadioButton(tag: QueryFilter.complete,
                            selection: $selectedFilter,
                            label: QueryFilter.complete.rawValue.capitalized)
                
                RadioButton(tag: QueryFilter.incomplete,
                            selection: $selectedFilter,
                            label: QueryFilter.incomplete.rawValue.capitalized)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView(todosListViewModel: TodosListViewModel(repository: MockTodosRepository()))
}
