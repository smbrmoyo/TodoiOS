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
    
    @Published private(set) var todos: [Todo] = []
    @Published var uiState: UIState = .idle
    @Published var selectedFilter: QueryFilter = .all
    @Published var sortBy: SortBy = .due
    @Published var sortDirection: SortDirection = .ascending
    @Published var showSettingsSheet: Bool = false
    @Published var showCreateSheet: Bool = false
    @Published var showEditSheet: Bool = false
    
    private var lastSelectedFilter: QueryFilter = .all
    private var lastSortBy: SortBy = .due
    private var lastSortDirection: SortDirection = .ascending
    
    // MARK: - Initializer
    
    init(repository: TodosRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    @MainActor
    func fetchTodos() async {
        uiState = todos.isEmpty ? .loading : .working
        do {
            todos = try await repository.fetchTodos(filter: selectedFilter,
                                                    sortBy: sortBy,
                                                    sortDirection: sortDirection)
            uiState = .idle
            lastSelectedFilter = selectedFilter
            lastSortBy = sortBy
            lastSortDirection = sortDirection
        } catch {
            uiState = .idle
            print(error)
        }
    }
    
    @MainActor
    func fetchTodosIfNeeded() async {
        guard selectedFilter != lastSelectedFilter ||
        sortBy != lastSortBy ||
        sortDirection != lastSortDirection else {
            return
        }
        
        await fetchTodos()
    }
    
    @MainActor
    func updateTodo(todo: Todo) async -> Bool {
        do {
            uiState = .working
            let result = try await repository.updateTodo(id: todo.id,
                                                         taskDescription: todo.taskDescription,
                                                         dueDate: todo.dueDate,
                                                         completed: todo.completed)
            
            guard let index = todos.firstIndex(where: { $0.id == result.id }) else { return false }
            
            todos[index] = result
            uiState = .idle
            
            return true
        } catch {
            print(error)
            uiState = .idle
            return false
        }
    }
}
