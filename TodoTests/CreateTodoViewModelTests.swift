//
//  CreateTodoViewModelTests.swift
//  TodoTests
//
//  Created by Brian Moyou on 30.10.24.
//

import XCTest
@testable import Todo

final class CreateTodoViewModelTests: XCTestCase {
    
    var viewModel: CreateTodoViewModel!
    var mockRepository: MockTodosRepository!
    var mockTodos: [Todo]!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTodos = try FileManager.loadJson(fileName: "Todos")
        mockRepository = MockTodosRepository()
        mockRepository.isTesting = true
        mockRepository.shouldFail = false
        viewModel = CreateTodoViewModel(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockRepository = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Test for Values
    
    func testInitialState() {
        XCTAssertEqual(viewModel.taskDescription, "")
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle initially.")
        XCTAssertEqual(viewModel.errorMessage, "", "Error message should be empty initially.")
        XCTAssertFalse(viewModel.showErrorAlert, "Error alert should not be shown initially.")
    }
    
    func testResetToInitialValues() async {
        // Given
        viewModel.taskDescription = "New Task"
        viewModel.dueDate = Date().addingTimeInterval(86400)
        
        // When
        await viewModel.createTodo()
        
        // Then
        XCTAssertEqual(viewModel.taskDescription, "")
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle initially.")
        XCTAssertEqual(viewModel.errorMessage, "", "Error message should be empty initially.")
        XCTAssertFalse(viewModel.showErrorAlert, "Error alert should not be shown initially.")
    }
    
    // MARK: - Test for Creation
    
    func testCreateTodSuccessful() async {
        // Given
        viewModel.taskDescription = "New Task"
        viewModel.dueDate = Date().addingTimeInterval(86400)
        mockRepository.shouldFail = false
        
        // When
        await viewModel.createTodo()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after successful creation.")
        XCTAssertFalse(viewModel.showErrorAlert, "Error alert should not be shown after successful creation.")
        XCTAssertEqual(viewModel.errorMessage, "", "Error message should be empty after successful creation.")
    }
    
    func testCreateTodoFailure() async {
        // Given
        viewModel.taskDescription = "New Task"
        viewModel.dueDate = Date().addingTimeInterval(86400) 
        mockRepository.shouldFail = true
        
        // When
        await viewModel.createTodo()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should return to idle after failed creation.")
        XCTAssertTrue(viewModel.showErrorAlert, "Error alert should be shown after failed creation.")
        XCTAssertEqual(viewModel.errorMessage, "There was error creating your Tasks.", "Error message should be set correctly after failed creation.")
    }
    
    // MARK: - Test UI State
    
    func testCreateTodoUIStateDuringProcessing() async {
        // Given
        viewModel.taskDescription = "New Task"
        viewModel.dueDate = Date().addingTimeInterval(86400)
        mockRepository.shouldFail = false
        
        let expectation = XCTestExpectation(description: "UI state should be working while createTodo is executing.")
        
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    expectation.fulfill()
                }
            }
        }
        
        // When
        await viewModel.createTodo()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after creation completes.")
        await fulfillment(of: [expectation], timeout: 3.0)
    }
    
    func testSaveButtonDisabled() {
        // Given
        viewModel.taskDescription = ""
        
        // When
        
        // Then
        XCTAssertTrue(viewModel.disabled)
    }
}

