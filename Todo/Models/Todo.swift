//
//  Todo.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

/// `Todo` Model
struct Todo: Identifiable, Codable, Equatable {
    let id: String
    var taskDescription: String
    var createdDate, dueDate: Date
    var completed: Bool
    
    private enum CodingKeys: String, CodingKey {
        case id
        case taskDescription
        case createdDate
        case dueDate
        case completed
    }
    
    /// DynamoDB does not support indexing on a `Bool`.
    /// The "completed" property coming back from the API will essentially be a `String`.
    /// We need to map it to a `Bool` in the decoding process
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        taskDescription = try container.decode(String.self, forKey: .taskDescription)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        dueDate = try container.decode(Date.self, forKey: .dueDate)
        
        let completedString = try container.decode(String.self, forKey: .completed)
        completed = (completedString as NSString).boolValue
    }
    
    init(id: String, taskDescription: String, createdDate: Date, dueDate: Date, completed: Bool) {
        self.id = id
        self.taskDescription = taskDescription
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.completed = completed
    }
}
