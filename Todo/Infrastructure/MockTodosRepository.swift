//
//  MockTodosRepository.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

final class MockTodosRepository: TodosRepositoryProtocol {
    
    var isTesting: Bool = false
    
    func fetchTodos(lastKey: String,
                    filter: QueryFilter,
                    sortBy: SortBy,
                    sortDirection: SortDirection) async throws -> [Todo] {
        do {
            let result: [Todo] = try FileManager.loadJson(fileName: "Todos")
            try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
            
            return result.filter(filter.filter()).sorted(by: sortBy.comparator(direction: sortDirection))
        } catch {
            print(error)
            throw error
        }
    }
    
    func getTodo(_ id: String) async throws -> Todo {
        do {
            let result: [Todo] = try FileManager.loadJson(fileName: "Todos")
            try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
            
            return result.randomElement()!
        } catch {
            print(error)
            throw error
        }
    }
    
    func createTodo(taskDescription: String,
                    dueDate: Date) async throws -> Todo {
        try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
        
        return .init(id: UUID().uuidString,
                     taskDescription: taskDescription,
                     createdDate: Date.now,
                     dueDate: dueDate,
                     completed: false)
    }
    
    func updateTodo(id: String,
                    taskDescription: String,
                    dueDate: Date,
                    createdDate: Date,
                    completed: Bool) async throws -> Todo {
        do {
            let todos: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            guard var todoToUpdate = todos.first(where: { $0.id == id }) else {
                throw NetworkError.custom(message: "No Todo Found.")
            }
            
            todoToUpdate.completed = completed
            todoToUpdate.taskDescription = taskDescription
            todoToUpdate.dueDate = dueDate
            
            try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
            
            return todoToUpdate
        } catch {
            print(error)
            throw error
        }
    }
    
    func deleteTodo(id: String) async throws -> Todo {
        do {
            let todos: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            guard let todoToDelete = todos.first(where: { $0.id == id }) else {
                throw NetworkError.custom(message: "No Todo Found.")
            }
            
            try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
            
            return todoToDelete
        } catch {
            print(error)
            throw error
        }
    }
    
}
