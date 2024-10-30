//
//  Endpoint.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import Foundation

enum Endpoint {
    private var baseURL: String { "http://localhost:3000/tasks/" }
    
    case getTodo(String), fetchTodos, createTodo, updateTodo(String), deleteTodo(String)
    
    var urlString: String {
        switch self {
        case .getTodo(let id), .deleteTodo(let id), .updateTodo(let id):
            return baseURL + id
        case .fetchTodos, .createTodo:
            return baseURL
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getTodo(_), .fetchTodos: "GET"
        case .deleteTodo(_): "DELETE"
        case .updateTodo(_): "PUT"
        case .createTodo: "POST"
        }
    }
}
