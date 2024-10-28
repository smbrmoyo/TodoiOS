//
//  Task.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

/// `Task` Model
struct Task: Identifiable, Codable {
    let id: UUID
    var taskDescription: String
    var createdDate, dueDate: Date
    var completed: Bool
}
