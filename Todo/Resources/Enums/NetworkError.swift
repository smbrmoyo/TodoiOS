//
//  NetworkError.swift
//  Todo
//
//  Created by Brian Moyou on 28.10.24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case badGateway
    case serverError
    case serviceUnavailable
    case unknownError
    case custom(message: String)
}
