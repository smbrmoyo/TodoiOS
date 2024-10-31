//
//  Endpoint.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import Foundation

enum Endpoint {
    private var baseURL: String { "https://todobackend-1056073512918.us-east5.run.app/tasks/" }
    
    case getTodo(String), fetchTodos, createTodo, updateTodo(String), deleteTodo(String)
    
    var urlString: String {
        switch self {
        case .getTodo(let id), .deleteTodo(let id), .updateTodo(let id):
            return baseURL + id
        case  .createTodo:
            return baseURL
        case .fetchTodos:
            return baseURL + "fetch"
        }
    }
    
    var httpMethod: String {
        switch self {
        case .getTodo(_): "GET"
        case .deleteTodo(_): "DELETE"
        case .updateTodo(_): "PUT"
        case .createTodo, .fetchTodos: "POST"
        }
    }
}
