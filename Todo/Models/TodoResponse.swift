//
//  TodoResponse.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import Foundation

struct TodoResponse: Codable {
    let data: Todo
    let status: ResponseStatus 
}
