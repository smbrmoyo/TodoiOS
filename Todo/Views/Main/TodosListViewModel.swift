//
//  TodosListViewModel.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

@MainActor
class TodosListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: TodosRepositoryProtocol
    @Published var todos: [Todo] = []
    @Published var selectedFilter: QueryFilter = .all
    @Published var sortBy: SortBy = .due
    @Published var sortDirection: SortDirection = .ascending
    
    // MARK: - Initializer
    
    init(repository: TodosRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Functions
    
    func fetchTodos() async {
        do {
            todos = try await repository.fetchTodos(filter: selectedFilter,
                                                    sortBy: sortBy,
                                                    sortDirection: sortDirection)
        } catch {
            print(error)
        }
    }
}
