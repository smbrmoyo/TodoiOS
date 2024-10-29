//
//  TodosListIdleView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct TodosListIdleView: View {
    @ObservedObject var viewModel: TodosListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.todos) { todo in
                    TodoView(todo: todo, viewModel: viewModel)
                }
            }
        }
    }
}

#Preview {
    TodosListIdleView(viewModel: TodosListViewModel(repository: MockTodosRepository()))
}
