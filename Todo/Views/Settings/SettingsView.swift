//
//  SettingsView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var todosListViewModel: TodosListViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                FiltersView(selectedFilter: $todosListViewModel.selectedFilter)
                
                SortByView(sortBy: $todosListViewModel.sortBy)
                
                SortDirectionView(sortDirection: $todosListViewModel.sortDirection)
                
                Button("Save") {
                    todosListViewModel.showSettingsSheet = false
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .modifier(SettingsViewModifier(todosListViewModel: todosListViewModel))
        }
    }
}

#Preview {
    SettingsView(todosListViewModel: TodosListViewModel(repository: MockTodosRepository()))
}
