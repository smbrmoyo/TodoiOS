//
//  FetchTodosResponse.swift
//  Todo
//
//  Created by Brian Moyou on 30.10.24.
//

import Foundation

struct FetchTodosResponse: Codable {
    let data: [Todo]
    let status: ResponseStatus
}
