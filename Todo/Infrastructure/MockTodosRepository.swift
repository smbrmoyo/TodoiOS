//
//  MockTodosRepository.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

final class MockTodosRepository: TodosRepositoryProtocol {
    
    var isTesting: Bool = false
    var shouldFail: Bool = true
    
    func fetchTodos(lastKey: String,
                    filter: QueryFilter,
                    sortBy: SortBy,
                    sortDirection: SortDirection) async throws -> [Todo] {
        
        guard !shouldFail else {
            let errors: [NetworkError] = [
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .badGateway,
                .serverError,
                .serviceUnavailable,
                .unknownError,
                .custom(message: "A random custom error occurred.")
            ]
            
            throw errors.randomElement()!
        }
        
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
        
        guard !shouldFail else {
            let errors: [NetworkError] = [
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .badGateway,
                .serverError,
                .serviceUnavailable,
                .unknownError,
                .custom(message: "A random custom error occurred.")
            ]
            
            throw errors.randomElement()!
        }
        
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
                    dueDate: Date,
                    completed: Bool) async throws -> Todo {
        
        guard !shouldFail else {
            let errors: [NetworkError] = [
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .badGateway,
                .serverError,
                .serviceUnavailable,
                .unknownError,
                .custom(message: "A random custom error occurred.")
            ]
            
            throw errors.randomElement()!
        }
        
        try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
        
        return .init(id: UUID().uuidString,
                     taskDescription: taskDescription,
                     createdDate: Date.now,
                     dueDate: dueDate,
                     completed: completed)
    }
    
    func updateTodo(todo: Todo) async throws -> Todo {
        
        guard !shouldFail else {
            let errors: [NetworkError] = [
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .badGateway,
                .serverError,
                .serviceUnavailable,
                .unknownError,
                .custom(message: "A random custom error occurred.")
            ]
            
            throw errors.randomElement()!
        }
        
        do {
            let todos: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            guard let _ = todos.first(where: { $0.id == todo.id }) else {
                throw NetworkError.custom(message: "No Todo Found.")
            }
            
            try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
            
            return todo
        } catch {
            print(error)
            throw error
        }
    }
    
    func deleteTodo(id: String) async throws {
        
        guard !shouldFail else {
            let errors: [NetworkError] = [
                .badRequest,
                .unauthorized,
                .forbidden,
                .notFound,
                .badGateway,
                .serverError,
                .serviceUnavailable,
                .unknownError,
                .custom(message: "A random custom error occurred.")
            ]
            
            throw errors.randomElement()!
        }
        
        do {
            let todos: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            guard let _ = todos.first(where: { $0.id == id }) else {
                throw NetworkError.custom(message: "No Todo Found.")
            }
            
            try await Task.sleep(for: .seconds(isTesting ? 0 : 1))
        } catch {
            print(error)
            throw error
        }
    }
    
}
