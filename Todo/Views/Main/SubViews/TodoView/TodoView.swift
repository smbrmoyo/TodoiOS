//
//  TodoView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct TodoView: View {
    @State private var todo: Todo
    @ObservedObject var viewModel: TodosListViewModel
    @StateObject var todoViewModel: TodoViewModel
    
    init(todo: Todo,
         viewModel: TodosListViewModel,
         repository: TodosRepositoryProtocol = TodosRepository()) {
        self._todo = State(initialValue: todo)
        self._todoViewModel = StateObject(wrappedValue: TodoViewModel(todo: todo, repository: repository))
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.background)
            
            HStack {
                NavigationLink {
                    EditTodoView(todo: todo, viewModel: viewModel)
                } label: {
                    Image("Vector")
                        .padding()
                }
                .frame(height: 100)
                
                VStack(alignment: .leading) {
                    Text(todo.taskDescription)
                        .fontWeight(.medium)
                    
                    Text("Due: \(todo.dueDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                        .fontWeight(viewModel.sortBy == .due ? .medium : .regular)
                        .foregroundStyle(todo.dueDate < .now ? .gray : .accent)
                    
                    Text("Created: \(todo.createdDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                        .fontWeight(viewModel.sortBy == .created ? .medium : .regular)
                }
                .lineLimit(1)
                .truncationMode(.tail)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button {
                        Task {
                            let result = await todoViewModel.toggleCompletedStatus(todo: todo)
                            
                            guard result != .emptyTodo else { return }
                            
                            todo = result
                        }
                    } label: {
                        Image(todo.completed ? "Check-box" : "Check-box-outline-blank")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    Button {
                        viewModel.toggleDeleteAlert(true)
                    } label: {
                        Image("delete")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                }
            }
            .padding(.horizontal, 8)
        }
        .frame(height: 100)
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .working(uiState: todoViewModel.uiState)
        .alert("Do you want to delete this Task?",
               isPresented: $viewModel.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteTodo(id: todo.id)
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
               .alert("Error", isPresented: $todoViewModel.showErrorAlert) {
                   Button("OK") {}
                   
                   Button("Retry") {
                       Task {
                           let result = await todoViewModel.toggleCompletedStatus(todo: todo)
                           
                           guard result != .emptyTodo else { return }
                           
                           todo = result
                       }
                   }
               } message: {
                   Text(todoViewModel.errorMessage)
               }
    }
}

#Preview {
    TodoView(todo: Todo(id: "1C78FE76-8521-4E07-89AD-0F2C7A21C819",
                        taskDescription: "Buy groceries",
                        createdDate: .now,
                        dueDate: .now.addingTimeInterval(86400),
                        completed: .random()),
             viewModel: TodosListViewModel(repository: MockTodosRepository()),
             repository: MockTodosRepository())
}
