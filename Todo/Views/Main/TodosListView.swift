//
//  TodosListView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct TodosListView: View {
    @StateObject var viewModel: TodosListViewModel = TodosListViewModel(repository: MockTodosRepository())
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.todos) { todo in
                        Text(todo.taskDescription)
                    }
                }
            }
            .task {
                await viewModel.fetchTodos()
            }
        }
    }
}

#Preview {
    TodosListView()
}
