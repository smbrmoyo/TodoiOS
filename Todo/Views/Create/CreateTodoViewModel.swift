//
//  CreateTodoViewModel.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

class CreateTodoViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: TodosRepositoryProtocol
    @Published var taskDescription: String = ""
    @Published var dueDate: Date = .now
    
    // MARK: - Initializer
    
    init(repository: TodosRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    @MainActor
    func createTodo() async {
        do {
            let _ = try await repository.createTodo(taskDescription: taskDescription,
                                                    createdDate: .now,
                                                    dueDate: dueDate)
        } catch {
            print(error)
        }
    }
}