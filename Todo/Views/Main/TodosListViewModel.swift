//
//  TodosListViewModel.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

final class TodosListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: TodosRepositoryProtocol
    
    @Published private(set) var todos: [Todo] = []
    @Published var uiState: UIState = .idle
    @Published var isRefreshing: Bool = false
    @Published var selectedFilter: QueryFilter = .all
    @Published var sortBy: SortBy = .due
    @Published var sortDirection: SortDirection = .ascending
    
    @Published var showSettingsSheet: Bool = false
    @Published var showCreateSheet: Bool = false
    @Published var showEditSheet: Bool = false
    
    @Published var showDeleteAlert: Bool = false
    @Published var showErrorAlert: Bool = false
    @Published private(set) var errorMessage: String = ""
    @Published private(set) var disabled: Bool = false
    
    private var lastSelectedFilter: QueryFilter = .all
    private var lastSortBy: SortBy = .due
    private var lastSortDirection: SortDirection = .ascending
    private var lastKey: String = ""
    
    // MARK: - Initializer
    
    init(repository: TodosRepositoryProtocol = TodosRepository()) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    @MainActor
    func fetchTodos() async {
        uiState = todos.isEmpty ? .loading : isRefreshing ? .idle : .working
        do {
            todos = try await repository.fetchTodos(lastKey: lastKey,
                                                    filter: selectedFilter,
                                                    sortBy: sortBy,
                                                    sortDirection: sortDirection)
            uiState = .idle
            lastSelectedFilter = selectedFilter
            lastSortBy = sortBy
            lastSortDirection = sortDirection
            isRefreshing = false
        } catch {
            uiState = .idle
            isRefreshing = false
            errorMessage = "There was error fetching your Tasks."
            showSettingsSheet = false
            showErrorAlert = true
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
        guard todo.dueDate > .now || !todo.taskDescription.isEmpty else {
            disabled = true
            return false
        }
        do {
            uiState = .working
            let result = try await repository.updateTodo(id: todo.id,
                                                         taskDescription: todo.taskDescription,
                                                         dueDate: todo.dueDate,
                                                         createdDate: todo.createdDate,
                                                         completed: todo.completed)
            
            guard let index = todos.firstIndex(where: { $0.id == result.id }) else { return false }
            
            todos[index] = result
            uiState = .idle
            
            return true
        } catch {
            errorMessage = "There was error updating your Task."
            showErrorAlert = true
            uiState = .idle
            return false
        }
    }
    
    @MainActor
    func deleteTodo(id: String) async -> Bool {
        do {
            uiState = .working
            try await repository.deleteTodo(id: id)
            
            guard let index = todos.firstIndex(where: { $0.id == id }) else { return false }
            
            todos.remove(at: index)
            uiState = .idle
            
            return true
        } catch {
            errorMessage = "There was error deleting your Task."
            showErrorAlert = true
            uiState = .idle
            return false
        }
    }
}
