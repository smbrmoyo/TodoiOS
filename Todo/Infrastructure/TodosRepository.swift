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
                    dueDate: Date) async throws -> Todo {
        do {
            let result: TodoResponse = try await makeRequest(from: Endpoint.createTodo.urlString,
                                                             method: Endpoint.createTodo.httpMethod,
                                                             body: ["taskDecription": taskDescription,
                                                                    "dueDate": dueDate])
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    func updateTodo(id: String,
                    taskDescription: String,
                    dueDate: Date,
                    createdDate: Date,
                    completed: Bool) async throws -> Todo {
        do {
            let result: TodoResponse = try await makeRequest(from: Endpoint.updateTodo(id).urlString,
                                                             method: Endpoint.updateTodo("").httpMethod,
                                                             parameters: ["id": id,
                                                                          "taskDecription": taskDescription,
                                                                          "createdDate": createdDate.ISO8601Format(),
                                                                          "dueDate": dueDate.ISO8601Format(),
                                                                          "completed": String(completed)])
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    func deleteTodo(id: String) async throws -> Todo {
        do {
            let result: TodoResponse = try await makeRequest(from: Endpoint.deleteTodo(id).urlString,
                                                             method: Endpoint.deleteTodo("").httpMethod,
                                                             parameters: ["id": id])
            
            return result.data
        } catch {
            print(error)
            throw error
        }
    }
    
    
}
