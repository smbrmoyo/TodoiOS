//
//  TodosRepository.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import Foundation

final class TodosRepository: TodosRepositoryProtocol {
    
    func fetchTodos(lastKey: String,
                    filter: QueryFilter,
                    sortBy: SortBy,
                    sortDirection: SortDirection) async throws -> [Todo] {
        do {
            let result: FetchTodosResponse = try await makeRequest(from: Endpoint.fetchTodos.urlString,
                                                                   parameters: ["lastKey": lastKey,
                                                                                "completed": filter.queryParameter,
                                                                                "sort_by": sortBy.sortKey(with: sortDirection)])
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    func getTodo(_ id: String) async throws -> Todo {
        do {
            let result: TodoResponse = try await makeRequest(from: Endpoint.getTodo(id).urlString)
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    func createTodo(taskDescription: String,
                    dueDate: Date,
                    completed: Bool) async throws -> Todo {
        do {
            let result: TodoResponse = try await makeRequest(from: Endpoint.createTodo.urlString,
                                                             method: Endpoint.createTodo.httpMethod,
                                                             body: ["taskDescription": taskDescription,
                                                                    "createdDate": Date.now.ISO8601Format(),
                                                                    "dueDate": dueDate.ISO8601Format(),
                                                                    "completed": String(completed)])
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    func updateTodo(todo: Todo) async throws -> Todo {
        do {
            let result: TodoResponse = try await makeRequest(from: Endpoint.updateTodo(todo.id).urlString,
                                                             method: Endpoint.updateTodo("").httpMethod,
                                                             body: ["id": todo.id,
                                                                    "taskDescription": todo.taskDescription,
                                                                    "createdDate": todo.createdDate.ISO8601Format(),
                                                                    "dueDate": todo.dueDate.ISO8601Format(),
                                                                    "completed": String(todo.completed)])
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    func deleteTodo(id: String) async throws {
        do {
            let result: DeleteTodoResponse = try await makeRequest(from: Endpoint.deleteTodo(id).urlString,
                                                                   method: Endpoint.deleteTodo("").httpMethod,
                                                                   parameters: ["id": id])
            
            guard result.status == .SUCCESS else {
                throw NetworkError.unknownError
            }
        } catch {
            print(error)
            throw error
        }
    }
    
    
}
