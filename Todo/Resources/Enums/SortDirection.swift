//
//  SortDirection.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

enum SortDirection: String, Identifiable, CaseIterable {
    case ascending, descending
    
    var id: String { rawValue }
}
