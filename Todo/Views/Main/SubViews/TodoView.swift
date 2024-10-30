//
//  TodoView.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import SwiftUI

struct TodoView: View {
    var todo: Todo
    @ObservedObject var viewModel: TodosListViewModel
    
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
                    
                    Text("Created: \(todo.createdDate.formatted(date: .long, time: .omitted))")
                        .font(.subheadline)
                        .fontWeight(viewModel.sortBy == .created ? .medium : .regular)
                }
                .lineLimit(1)
                .truncationMode(.tail)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Image(todo.completed ? "Check-box" : "Check-box-outline-blank")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Button {
                        viewModel.showDeleteAlert = true
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
        .alert("Do you want to delete this Task?",
               isPresented: $viewModel.showDeleteAlert) {
            Button("Delete", role: .destructive) {
                Task {
                    await viewModel.deleteTodo(id: todo.id)
                }
            }
            
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    TodosListView()
}
