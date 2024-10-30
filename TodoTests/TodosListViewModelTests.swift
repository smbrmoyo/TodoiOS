//
//  TodosListViewModelTests.swift
//  TodoTests
//
//  Created by Brian Moyou on 30.10.24.
//

import XCTest
@testable import Todo

final class TodosListViewModelTests: XCTestCase {
    
    var viewModel: TodosListViewModel!
    var mockRepository: MockTodosRepository!
    var mockTodos: [Todo]!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        mockTodos = try FileManager.loadJson(fileName: "Todos")
        mockRepository = MockTodosRepository()
        mockRepository.shouldFail = false
        mockRepository.isTesting = true
        viewModel = TodosListViewModel(repository: mockRepository)
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
        mockRepository = nil
        mockTodos = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Test for Values
    
    func testInitialState() {
        
        XCTAssertEqual(viewModel.todos, [])
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertEqual(viewModel.isRefreshing, false)
        XCTAssertEqual(viewModel.selectedFilter, .all)
        XCTAssertEqual(viewModel.sortBy, .due)
        XCTAssertEqual(viewModel.sortDirection, .ascending)
        
        XCTAssertEqual(viewModel.showSettingsSheet, false)
        XCTAssertEqual(viewModel.showCreateSheet, false)
        XCTAssertEqual(viewModel.showEditSheet, false)
        
        XCTAssertEqual(viewModel.showDeleteAlert, false)
        XCTAssertEqual(viewModel.showErrorAlert, false)
        XCTAssertEqual(viewModel.errorMessage, "")
    }
    
    
    // MARK: - Tests for Fetching Todos
    
    func testFetchTodos_success() async {
        // Given
        mockRepository.shouldFail = false
        
        // When
        await viewModel.fetchTodos()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertFalse(viewModel.todos.isEmpty, "Todos should be fetched successfully")
        XCTAssertEqual(viewModel.todos.count, mockTodos.count, "Expected todos count should match mock data")
        XCTAssertFalse(viewModel.showErrorAlert, "Error alert should not be shown on success")
    }
    
    func testFetchTodos_failure() async {
        // Given
        mockRepository.shouldFail = true
        
        // When
        await viewModel.fetchTodos()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertTrue(viewModel.todos.isEmpty, "Todos should be empty on fetch failure")
        XCTAssertTrue(viewModel.showErrorAlert, "Error alert should be shown on failure")
        XCTAssertEqual(viewModel.errorMessage, "There was error fetching your Tasks.")
    }
    
    // MARK: - Tests for Update Todo
    
    func testUpdateTodo_success() async {
        // Given
        let todo = mockTodos.randomElement()!
        var todoToUpdate = todo
        let newDueDate = Date.now.addingTimeInterval(7200)
        let newDescription = "New Task Description"
        todoToUpdate.dueDate = newDueDate
        todoToUpdate.taskDescription = newDescription
        
        // When
        await viewModel.fetchTodos()
        let success = await viewModel.updateTodo(todo: todoToUpdate)
        let updatedTodo = viewModel.todos.first(where: { $0.id == todoToUpdate.id })
        
        // Then
        XCTAssertNotNil(updatedTodo)
        XCTAssertEqual(updatedTodo!.dueDate, newDueDate)
        XCTAssertEqual(updatedTodo!.taskDescription, newDescription)
        XCTAssertTrue(success, "Update should succeed")
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertFalse(viewModel.showErrorAlert, "Error alert should not be shown on success")
    }
    
    func testUpdateTodo_failure() async {
        // Given
        
        mockRepository.shouldFail = true
        
        // When
        await viewModel.fetchTodos()
        let success = await viewModel.updateTodo(todo: mockTodos.randomElement()!)
        
        // Then
        XCTAssertFalse(success, "Update should fail")
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertTrue(viewModel.showErrorAlert, "Error alert should be shown on failure")
        XCTAssertEqual(viewModel.errorMessage, "There was error updating your Task.")
    }
    
    // MARK: - Tests for Delete Todo
    
    func testDeleteTodo_success() async {
        // Given
        let id = mockTodos.randomElement()!.id
        
        // When
        await viewModel.fetchTodos()
        let success = await viewModel.deleteTodo(id: id)
        
        // Then
        XCTAssertTrue(success, "Delete should succeed")
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertFalse(viewModel.todos.contains { $0.id == id }, "Deleted todo should not be in todos list")
        XCTAssertFalse(viewModel.showErrorAlert, "Error alert should not be shown on success")
    }
    
    func testDeleteTodo_failure() async {
        // Given
        mockRepository.shouldFail = true
        let id = mockTodos.randomElement()!.id
        
        // When
        let success = await viewModel.deleteTodo(id: id)
        
        // Then
        XCTAssertFalse(success, "Delete should fail")
        XCTAssertEqual(viewModel.uiState, .idle)
        XCTAssertTrue(viewModel.showErrorAlert, "Error alert should be shown on failure")
        XCTAssertEqual(viewModel.errorMessage, "There was error deleting your Task.")
    }
    
    // MARK: - Tests for UIState
    
    func testFetchTodosUIStateLoadingDuringInitialLoad() async {
        // Given
        mockRepository.shouldFail = false
        
        let expectation = XCTestExpectation(description: "UI state should be working while fetchTodos is executing.")
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .loading {
                    expectation.fulfill()
                }
            }
        }
        
        // When
        await viewModel.fetchTodos()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after fetchTodos completes.")
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testFetchTodosUIStateWorkingDuringProcessing() async {
        // Given
        mockRepository.shouldFail = false
        await viewModel.fetchTodos()
        
        let expectation = XCTestExpectation(description: "UI state should be working while fetchTodos is executing.")
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    expectation.fulfill()
                }
            }
        }
        
        // When
        await viewModel.fetchTodos()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after fetchTodos completes.")
        await fulfillment(of: [expectation], timeout: 2.0)
    }
    
    func testFetchTodosIfNeededUIStateDuringProcessing() async {
        // Given
        await viewModel.fetchTodos()
        viewModel.selectedFilter = .complete
        mockRepository.shouldFail = false
        
        let expectation = XCTestExpectation(description: "UI state should be working while fetchTodosIfNeeded is executing.")
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    expectation.fulfill()
                }
            }
        }
        
        // When
        await viewModel.fetchTodosIfNeeded()
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after fetchTodosIfNeeded completes.")
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testUpdateTodoUIStateDuringProcessing() async {
        // Given
        await viewModel.fetchTodos()
        let todo = mockTodos.randomElement()!
        var todoToUpdate = todo
        let newDueDate = Date.now.addingTimeInterval(7200)
        let newDescription = "New Task Description"
        todoToUpdate.dueDate = newDueDate
        todoToUpdate.taskDescription = newDescription
        
        // When
        let expectation = XCTestExpectation(description: "UI state should be working while updateTodo is executing.")
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    expectation.fulfill()
                }
            }
        }
        
        // When
        let _ = await viewModel.updateTodo(todo: todo)
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after updateTodo completes.")
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testDeleteTodoUIStateDuringProcessing() async {
        // Given
        await viewModel.fetchTodos()
        let id = mockTodos.randomElement()!.id
        
        let expectation = XCTestExpectation(description: "UI state should be working while deleteTodo is executing.")
        
        Task {
            await MainActor.run {
                if viewModel.uiState == .working {
                    expectation.fulfill()
                }
            }
        }
        
        // When
        let _ = await viewModel.deleteTodo(id: id)
        
        // Then
        XCTAssertEqual(viewModel.uiState, .idle, "UI state should be idle after deleteTodo completes.")
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testDisableWhenWrongInput() async {
        // Given
        let todo = Todo(id: UUID().uuidString,
                        taskDescription: "",
                        createdDate: .distantFuture,
                        dueDate: .distantPast,
                        completed: Bool.random())
        
        // When
        let _ = await viewModel.updateTodo(todo: todo)
        
        // Then
        
        XCTAssertTrue(viewModel.disabled)
    }
    
}

