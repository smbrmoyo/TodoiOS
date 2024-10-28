//
//  QueryFilter.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

enum QueryFilter: String, Identifiable, CaseIterable {
    case all, complete, incomplete
    
    var id: String { rawValue }
    
    /// Returns a closure that filters `Todo` items based on the `QueryFilter` case.
    func filter() -> (Todo) -> Bool {
        switch self {
        case .all:
            return { _ in true } // No filtering, includes all items
        case .complete:
            return { $0.completed }
        case .incomplete:
            return { !$0.completed }
        }
    }
}
