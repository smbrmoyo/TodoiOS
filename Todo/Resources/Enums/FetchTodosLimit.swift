//
//  FetchTodosLimit.swift
//  Todo
//
//  Created by Brian Moyou on 31.10.24.
//

import Foundation

enum FetchTodosLimit: Int, Identifiable, CaseIterable {
    case ten = 10
    case twenty = 20
    
    var id: Int { rawValue }
}
