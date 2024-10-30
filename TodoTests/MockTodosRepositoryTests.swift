//
//  MockTodosRepositoryTests.swift
//  TodoTests
//
//  Created by Brian Moyou on 30.10.24.
//

import XCTest
@testable import Todo

final class MockTodosRepositoryTests: XCTestCase {
    private var mockRepository: MockTodosRepository!
    var mockTodos: [Todo]!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockRepository = MockTodosRepository()
        mockTodos = try FileManager.loadJson(fileName: "Todos")
    }
    
    override func tearDownWithError() throws {
        mockRepository = nil
        mockTodos = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - fetchTodos Tests
    
    func testFetchTodos_Success() async throws {
        // Given
        mockRepository.shouldFail = false
        
        // When
        let todos = try await mockRepository.fetchTodos(lastKey: "", filter: .all, sortBy: .due, sortDirection: .ascending)
        
        // Then
        XCTAssertFalse(todos.isEmpty, "Expected non-empty todos array on successful fetch")
    }
    
    func testFetchTodos_Failure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When/Then
        do {
            let _ = try await mockRepository.fetchTodos(lastKey: "", filter: .all, sortBy: .due, sortDirection: .ascending)
            XCTFail("Expected fetchTodos to throw an error")
        } catch {
            XCTAssertNotNil(error, "Expected an error to be thrown")
        }
    }
    
    // MARK: - getTodo Tests
    
    func testGetTodo_Success() async throws {
        // Given
        mockRepository.shouldFail = false
        
        // When
        let todo = try await mockRepository.getTodo("sampleID")
        
        // Then
        XCTAssertNotNil(todo, "Expected a todo to be returned on successful fetch")
    }
    
    func testGetTodo_Failure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When/Then
        do {
            let _ = try await mockRepository.getTodo("sampleID")
            XCTFail("Expected getTodo to throw an error")
        } catch {
            XCTAssertNotNil(error, "Expected an error to be thrown")
        }
    }
    
    // MARK: - createTodo Tests
    
    func testCreateTodo_Success() async throws {
        // Given
        mockRepository.shouldFail = false
        let description = "Test Task"
        let dueDate = Date().addingTimeInterval(86400)
        
        // When
        let createdTodo = try await mockRepository.createTodo(taskDescription: description, dueDate: dueDate, completed: false)
        
        // Then
        XCTAssertEqual(createdTodo.taskDescription, description, "Task description should match input")
        XCTAssertEqual(createdTodo.dueDate, dueDate, "Due date should match input")
    }
    
    func testCreateTodo_Failure() async {
        // Given
        mockRepository.shouldFail = true
        let description = "Test Task"
        let dueDate = Date().addingTimeInterval(86400)
        
        // When/Then
        do {
            let _ = try await mockRepository.createTodo(taskDescription: description, dueDate: dueDate, completed: false)
            XCTFail("Expected createTodo to throw an error")
        } catch {
            XCTAssertNotNil(error, "Expected an error to be thrown")
        }
    }
    
    // MARK: - updateTodo Tests
    
    func testUpdateTodo_Success() async throws {
        // Given
        mockRepository.shouldFail = false
        let todo = mockTodos.randomElement()!
        let taskDescription = "Updated Task"
        let dueDate = Date().addingTimeInterval(172800)
        let completed = true
        
        // When
        let updatedTodo = try await mockRepository.updateTodo(id: todo.id, taskDescription: taskDescription, dueDate: dueDate, createdDate: todo.createdDate, completed: completed)
        
        // Then
        XCTAssertEqual(updatedTodo.taskDescription, taskDescription, "Updated description should match input")
        XCTAssertEqual(updatedTodo.dueDate, dueDate, "Updated due date should match input")
        XCTAssertEqual(updatedTodo.completed, completed, "Updated completion status should match input")
    }
    
    func testUpdateTodo_Failure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When/Then
        do {
            let _ = try await mockRepository.updateTodo(id: "sampleID", taskDescription: "Updated Task", dueDate: Date(), createdDate: Date(), completed: true)
            XCTFail("Expected updateTodo to throw an error")
        } catch {
            XCTAssertNotNil(error, "Expected an error to be thrown")
        }
    }
    
    // MARK: - deleteTodo Tests
    
    func testDeleteTodo_Success() async throws {
        // Given
        mockRepository.shouldFail = false
        
        // When
        do {
            try await mockRepository.deleteTodo(id: mockTodos.randomElement()!.id)
        } catch {
            XCTFail("Expected deleteTodo to succeed without error")
        }
    }
    
    func testDeleteTodo_Failure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When/Then
        do {
            try await mockRepository.deleteTodo(id: "sampleID")
            XCTFail("Expected deleteTodo to throw an error")
        } catch {
            XCTAssertNotNil(error, "Expected an error to be thrown")
        }
    }
}

