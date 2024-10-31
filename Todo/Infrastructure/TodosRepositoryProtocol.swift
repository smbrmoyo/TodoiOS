//
//  TodosRepositoryProtocol.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

protocol TodosRepositoryProtocol {
    
    /**
     Fetches a list of todos based on specified filter, sorting criteria, and sort direction.
     
     - Parameters:
        - lastKey: The last evaluated key from the previous query, used for pagination.
        - filter: A `QueryFilter` specifying criteria to filter todos.
        - sortBy: A `SortBy` specifying the attribute by which to sort the todos.
        - sortDirection: A `SortDirection` specifying whether sorting is ascending or descending.
     
     - Returns: An array of `Todo` objects matching the filter and sorting criteria.
     
     - Throws: An error if the fetching process encounters an issue.
     */
    func fetchTodos(lastKey: String,
                    filter: QueryFilter,
                    sortBy: SortBy,
                    sortDirection: SortDirection) async throws -> [Todo]
    
    /**
     Retrieves a specific todo by its unique identifier.
     
     - Parameter id: The unique identifier of the todo to retrieve.
     - Returns: The `Todo` object with the specified ID.
     - Throws: An error if the todo cannot be found or retrieval fails.
     */
    func getTodo(_ id: String) async throws -> Todo
    
    /**
     Creates a new todo with the specified task description, created date, and due date.
     
     - Parameters:
        - taskDescription: A `String` describing the task to be completed.
        - dueDate: A `Date` specifying the deadline for the todo.
        - completed: A `Bool` indicating whether the todo has been completed.
     
     - Returns: The newly created `Todo` object.
     
     - Throws: An error if the creation process fails.
     */
    func createTodo(taskDescription: String,
                    dueDate: Date,
                    completed: Bool) async throws -> Todo
    
    /**
     Updates an existing todo with new values for description, due date, and completion status.
     
     - Parameter id: The `Todo` to be updated.
     - Returns: The updated `Todo` object.
     - Throws: An error if the update process encounters an issue or the todo cannot be found.
     */
    func updateTodo(todo: Todo) async throws -> Todo
    
    /**
     Deletes a todo by its unique identifier.
     
     - Parameter id: The unique identifier of the todo to delete.
     - Throws: An error if the deletion process fails or the todo cannot be found.
     */
    func deleteTodo(id: String) async throws
}
