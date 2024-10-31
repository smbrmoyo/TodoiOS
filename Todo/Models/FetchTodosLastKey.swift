//
//  FetchTodosLastKey.swift
//  Todo
//
//  Created by Brian Moyou on 31.10.24.
//

import Foundation

struct FetchTodosLastKey: Codable {
    let id, type: String
    var createdDate, dueDate: String?
}
