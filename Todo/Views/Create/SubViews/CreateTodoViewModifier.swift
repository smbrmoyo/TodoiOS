//
//  CreateTodoViewModifier.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import SwiftUI

struct CreateTodoViewModifier: ViewModifier {
    @ObservedObject var viewModel: CreateTodoViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Create")
                        .font(.largeTitle)
                }
            }
            .working(uiState: viewModel.uiState)
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                Button("Retry") {
                    Task {
                        await viewModel.createTodo()
                    }
                }
                
                Button("OK") {}
            } message: {
                Text(viewModel.errorMessage)
            }
    }
}
