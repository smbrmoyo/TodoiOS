//
//  TodosListViewModifier.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct TodosListViewModifier: ViewModifier {
    @ObservedObject var viewModel: TodosListViewModel
    
    func body(content: Content) -> some View {
        content
            .task {
                await viewModel.fetchTodos()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        viewModel.showSettingsSheet = true
                    } label: {
                        Image(systemName: "gear")
                            .font(.system(.title))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Task List")
                        .font(.largeTitle)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showCreateSheet = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(.title))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $viewModel.showSettingsSheet, onDismiss: {
                Task {
                    await viewModel.fetchTodos()
                }
            }) {
                SettingsView(todosListViewModel: viewModel)
            }
            .sheet(isPresented: $viewModel.showCreateSheet) {
                CreateTodoView()
            }
    }
}