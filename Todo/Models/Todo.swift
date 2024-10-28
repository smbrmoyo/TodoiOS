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
    var taskDescription, createdDate, dueDate: String // Dates will be stored in the ISO format
    var completed: Bool
}
