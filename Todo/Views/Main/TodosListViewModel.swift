//
//  TodosListViewModel.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

class TodosListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: TodosRepositoryProtocol
    
    @Published var todos: [Todo] = []
    @Published var uiState: UIState = .idle
    @Published var selectedFilter: QueryFilter = .all
    @Published var sortBy: SortBy = .due
    @Published var sortDirection: SortDirection = .ascending
    @Published var showSettingsSheet: Bool = false
    @Published var showCreateSheet: Bool = false
    @Published var showEditSheet: Bool = false
    
    // MARK: - Initializer
    
    init(repository: TodosRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    @MainActor
    func fetchTodos() async {
        uiState = todos.isEmpty ? .loading : .idle
        do {
            todos = try await repository.fetchTodos(filter: selectedFilter,
                                                    sortBy: sortBy,
                                                    sortDirection: sortDirection)
            uiState = .idle
        } catch {
            uiState = .idle
            print(error)
        }
    }
    
    @MainActor
    func updateTodo(todo: Todo) async -> Bool {
        do {
            let result = try await repository.updateTodo(id: todo.id,
                                                         taskDescription: todo.taskDescription,
                                                         dueDate: todo.dueDate,
                                                         completed: todo.completed)
            
            guard let index = todos.firstIndex(where: { $0.id == result.id }) else { return false }
            
            todos[index] = result
            
            return true
        } catch {
            print(error)
            return false
        }
    }
}
