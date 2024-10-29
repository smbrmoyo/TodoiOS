//
//  TodosListView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct TodosListView: View {
    @StateObject var viewModel: TodosListViewModel = .init(repository: MockTodosRepository())
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.uiState == .loading {
                    TodosListLoadingView()
                } else if viewModel.todos.isEmpty {
                    TodosListEmptyView()
                } else {
                    TodosListIdleView(viewModel: viewModel)
                }
            }
            .modifier(TodosListViewModifier(viewModel: viewModel))
        }
    }
}

#Preview {
    TodosListView()
}
