//
//  SortBy.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

enum SortBy: String, Identifiable, CaseIterable {
    case due, created
    
    var id: String { rawValue }
    
    /// Returns a sorting closure that compares two `Todo` objects based on `SortBy` and `SortDirection`.
    func comparator(direction: SortDirection) -> (Todo, Todo) -> Bool {
        switch (self, direction) {
        case (.due, .ascending):
            return { $0.dueDate < $1.dueDate }
        case (.due, .descending):
            return { $0.dueDate > $1.dueDate }
        case (.created, .ascending):
            return { $0.createdDate < $1.createdDate }
        case (.created, .descending):
            return { $0.createdDate > $1.createdDate }
        }
    }
}
