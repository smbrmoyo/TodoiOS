//
//  MockTodosRepository.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

class MockTodosRepository: TodosRepositoryProtocol {
    
    func fetchTodos(filter: QueryFilter,
                    sortBy: SortBy,
                    sortDirection: SortDirection) async throws -> [Todo] {
        do {
            let result: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            return result.filter(filter.filter()).sorted(by: sortBy.comparator(direction: sortDirection))
        } catch {
            print(error)
            throw error
        }
    }
    
    func getTodo(_ id: String) async throws -> Todo {
        do {
            let result: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            return result.randomElement()!
        } catch {
            print(error)
            throw error
        }
    }
    
    func createTodo(taskDescription: String,
                    createdDate: Date,
                    dueDate: Date) async throws -> Todo {
        return .init(id: UUID().uuidString,
                     taskDescription: taskDescription,
                     createdDate: createdDate,
                     dueDate: dueDate,
                     completed: false)
    }
    
    func updateTodo(id: String,
                    taskDescription: String,
                    dueDate: Date,
                    completed: Bool) async throws -> Todo {
        do {
            let todos: [Todo] = try FileManager.loadJson(fileName: "Todos")
            
            guard var todoToUpdate = todos.first(where: { $0.id == id }) else {
                throw NetworkError.custom(message: "No Todo Found.")
            }
            
            todoToUpdate.completed = completed
            todoToUpdate.taskDescription = taskDescription
            todoToUpdate.dueDate = dueDate
            
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
            
            return todoToDelete
        } catch {
            print(error)
            throw error
        }
    }
    
}
