//
//  EditTodoView.swift
//  Todo
//
//  Created by Brian Moyou on 29.10.24.
//

import SwiftUI

struct EditTodoView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: TodosListViewModel
    @State private var todo: Todo
    
    init(todo: Todo, viewModel: TodosListViewModel) {
        self._todo = State(initialValue: todo)
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("", text: $todo.taskDescription)
                    .customTextField(title: "To-Do Item Name")
                
                CustomDatePicker(date: $todo.dueDate)
                    .customTextField(title: "Select Due Date")
                
                Button("Save") {
                    Task {
                        let success = await viewModel.updateTodo(todo: todo)
                        
                        guard success else { return }
                        
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.disabled)
                
                Spacer()
            }
            .modifier(EditTodoViewModifier(viewModel: viewModel))
        }
    }
}

#Preview {
    EditTodoView(todo: Todo(id: "1", taskDescription: "", createdDate: .now, dueDate: .now, completed: false), viewModel: TodosListViewModel(repository: MockTodosRepository()))
}
