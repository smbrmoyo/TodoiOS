//
//  CreateTodoViewModel.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

final class CreateTodoViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: TodosRepositoryProtocol
    
    @Published var taskDescription: String = ""
    @Published var dueDate: Date = .now
    @Published var uiState: UIState = .idle
    
    @Published var showErrorAlert: Bool = false
    @Published private(set) var errorMessage: String = ""
    var disabled: Bool {
        taskDescription.isEmpty
    }
    
    // MARK: - Initializer
    
    init(repository: TodosRepositoryProtocol = TodosRepository()) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    @MainActor
    func createTodo() async {
        uiState = .working
        do {
            let _ = try await repository.createTodo(taskDescription: taskDescription,
                                                    dueDate: dueDate,
                                                    completed: false)
            uiState = .idle
            taskDescription = ""
            dueDate = .now
        } catch {
            errorMessage = "There was error creating your Tasks."
            showErrorAlert = true
            uiState = .idle
        }
    }
}
