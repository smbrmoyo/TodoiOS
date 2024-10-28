//
//  Todo.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

/// `Todo` Model
struct Todo: Identifiable, Codable {
    let id: String
    var taskDescription: String
    var createdDate, dueDate: Date
    var completed: Bool
}
