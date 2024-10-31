//
//  TodoViewModel.swift
//  Todo
//
//  Created by Brian Moyou on 31.10.24.
//

import Foundation

final class TodoViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: TodosRepositoryProtocol
    
    private let id: String
    private(set) var taskDescription: String
    private(set) var dueDate: Date
    private(set) var createdDate: Date
    @Published private(set) var completed: Bool
    @Published var uiState: UIState = .idle
    @Published var isRefreshing: Bool = false
    @Published var selectedFilter: QueryFilter = .all
    @Published var sortBy: SortBy = .due
    @Published var sortDirection: SortDirection = .ascending
    
    @Published var showSettingsSheet: Bool = false
    @Published var showCreateSheet: Bool = false
    
    @Published var showDeleteAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var disabled: Bool = false
    
    // MARK: - Initializer
    
    init(todo: Todo, repository: TodosRepositoryProtocol) {
        self.id = todo.id
        self.taskDescription = todo.taskDescription
        self.dueDate = todo.dueDate
        self.createdDate = todo.createdDate
        self.completed = todo.completed
        
        self.repository = repository
    }
    
    // MARK: - Functions
    
    @MainActor
    func toggleCompletedStatus(todo: Todo) async -> Todo {
        var newTodo = todo
        newTodo.completed.toggle()
        
        do {
            uiState = .working
            let result = try await repository.updateTodo(todo: newTodo)
            
            uiState = .idle
            
            return result
        } catch {
            errorMessage = "There was error updating your Task."
            showErrorAlert = true
            uiState = .idle
            
            return .emptyTodo
        }
    }
}
