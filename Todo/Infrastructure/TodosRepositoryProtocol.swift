//
//  TodosRepositoryProtocol.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

protocol TodosRepositoryProtocol {
    func fetchTodos() async throws -> [Todo]
    
    func getTodo(_ id: String) async throws -> Todo
    
    func createTodo(taskDescription: String,
                    createdDate: String,
                    dueDate: String) async throws -> Todo
    
    func updateTodo(id: String,
                    taskDescription: String,
                    dueDate: String,
                    completed: Bool) async throws -> Todo
    
    func deleteTodo(id: String) async throws -> Todo
}
