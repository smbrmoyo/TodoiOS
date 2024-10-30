//
//  CreateTodoView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct CreateTodoView: View {
    @StateObject var viewModel: CreateTodoViewModel = .init()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("", text: $viewModel.taskDescription)
                    .customTextField(title: "To-Do Item Name")
                
                CustomDatePicker(date: $viewModel.dueDate)
                    .customTextField(title: "Select Due Date")
                
                Button("Save") {
                    Task {
                        await viewModel.createTodo()
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Create")
                        .font(.largeTitle)
                }
            }
            .working(uiState: viewModel.uiState)
        }
    }
}

#Preview {
    CreateTodoView(viewModel: CreateTodoViewModel(repository: MockTodosRepository()))
}
