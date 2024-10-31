//
//  TodosRepository.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import Foundation

final class TodosRepository: TodosRepositoryProtocol {
    
    func fetchTodos(lastKey: FetchTodosLastKey?,
                    filter: QueryFilter,
                    sortBy: SortBy,
                    sortDirection: SortDirection,
                    limit: Int) async throws -> FetchTodosResponse {
        do {
            var requestBody: [String: Any?] = [
                "completed": filter.queryParameter,
                "limit": limit,
                "sort_by": sortBy.sortKey(with: sortDirection)
            ]
            
            /// For Pagination
            if let lastKey = lastKey, let _ = lastKey.type {
                requestBody["lastKey"] = [
                    "id": lastKey.id,
                    "type": "Todo",
                    "\(sortBy)Date": sortBy == .due ? lastKey.dueDate : lastKey.createdDate
                ]
            } else if let lastKey = lastKey {
                requestBody["lastKey"] = [
                    "id": lastKey.id,
                    "completed": filter.queryParameter,
                    "\(sortBy)Date": sortBy == .due ? lastKey.dueDate : lastKey.createdDate
                ]
            }
            
            let result: FetchTodosResponse = try await makeRequest(from: Endpoint.fetchTodos.urlString,
                                                                   method: Endpoint.fetchTodos.httpMethod,
                                                                   body: requestBody)
            
            return result
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
    
    func bulkCreateTodos() async {
        await withTaskGroup(of: Void.self) { group in
            for i in 0...50 {
                group.addTask {
                    let dueDate = Date.now.addingTimeInterval(TimeInterval.random(in: 86_400...172_800))
                    
                    do {
                        _ = try await self.createTodo(taskDescription: "Task \(i)",
                                                      dueDate: dueDate,
                                                      completed: false)
                        
                    } catch {
                        print("Failed to create a task: \(error)")
                    }
                }
            }
        }
    }
    
    
}
