//
//  EditTodoViewModifier.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import SwiftUI

struct EditTodoViewModifier: ViewModifier {
    @ObservedObject var viewModel: TodosListViewModel
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Edit")
                        .font(.largeTitle)
                }
            }
            .working(uiState: viewModel.uiState)
            .alert("Error", isPresented: $viewModel.showErrorAlert) {
                
            } message: {
                Text(viewModel.errorMessage)
            }
    }
}
