//
//  TodoViewModelTests.swift
//  TodoTests
//
//  Created by Brian Moyou on 31.10.24.
//

import XCTest
import Combine
@testable import Todo

final class TodoViewModelTests: XCTestCase {
    
    var viewModel: TodoViewModel!
    var mockRepository: MockTodosRepository!
    var mockTodos: [Todo]!
    var todo: Todo!
    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTodos = try FileManager.loadJson(fileName: "Todos")
        todo = mockTodos.randomElement()!
        mockRepository = MockTodosRepository()
        mockRepository.shouldFail = false
        viewModel = TodoViewModel(todo: todo, repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        
        super.tearDown()
    }

    // MARK: - Initial Value Tests
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.taskDescription, todo.taskDescription)
        XCTAssertEqual(viewModel.dueDate, todo.dueDate)
        XCTAssertEqual(viewModel.createdDate, todo.createdDate)
        XCTAssertEqual(viewModel.completed, todo.completed)
        XCTAssertFalse(viewModel.showErrorAlert)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    // MARK: - Success and UI State Tests
    
    func testToggleCompletedStatus_Success() async {
        // Given
        mockRepository.shouldFail = false
        var updatedTodo = todo
        updatedTodo!.completed.toggle()
        
        let expectation = XCTestExpectation(description: "UI state should be working while toggleCompletedStatus is processing")
        
        // When
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    expectation.fulfill()
                }
            }
        }
        
        let result = await viewModel.toggleCompletedStatus(todo: todo)
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertEqual(result.completed, !todo.completed)
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    // MARK: - Failure Tests

    func testToggleCompletedStatus_Failure() async {
        // Given
        mockRepository.shouldFail = true
        
        // Expect the UI state to be working during processing
        let workingExpectation = XCTestExpectation(description: "UI state should be working during toggleCompletedStatus processing")
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    workingExpectation.fulfill()
                }
            }
        }
        
        // When
        let result = await viewModel.toggleCompletedStatus(todo: todo)
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertEqual(viewModel.errorMessage, "There was error updating your Task.")
        XCTAssertTrue(viewModel.showErrorAlert)
        XCTAssertEqual(result, .emptyTodo, "Expected empty todo on failure")
        await fulfillment(of: [workingExpectation], timeout: 1.0)
    }
    
}

