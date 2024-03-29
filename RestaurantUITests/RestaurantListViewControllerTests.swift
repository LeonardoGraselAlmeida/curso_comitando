//
//  RestaurantUITests.swift
//  RestaurantUITests
//
//  Created by Leonardo Almeida on 13/03/23.
//

import XCTest
import RestaurantDomain
@testable import RestaurantUI

final class RestaurantListViewControllerTests: XCTestCase {
    
    func test_init_does_not_load() throws {
        let (sut, service) = try makeSUT()
        
        XCTAssertTrue(service.methodsCalled.isEmpty)
        XCTAssertTrue(sut.restaurantCollection.isEmpty)
    }
    
    func test_viewDidLoad_should_be_called_load_service() throws {
        let (sut, service) = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.methodsCalled, [.load])
    }
    
    func test_load_returned_restaurantItems_data_and_restaurantCollection_does_not_empty() throws {
        let (sut, service) = try makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionResult(.success([RestaurantItem.makeItem()]))
        
        XCTAssertEqual(service.methodsCalled, [.load])
        XCTAssertEqual(sut.restaurantCollection.count, 1)
    }
    
    func test_load_returned_error_and_restaurantCollection_is_empty() throws {
        let (sut, service) = try makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(service.methodsCalled, [.load])
        XCTAssertEqual(sut.restaurantCollection.count, 0)
    }
    
    func test_pullToRefresh_should_be_called_load_service() throws {
        let (sut, service) = try makeSUT()
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load])
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load, .load])
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load, .load, .load])
    }
    
    func test_viewDidLoad_show_loading_indicator() throws {
        let (sut, _) = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
    }
    
    func test_load_when_completion_failure_should_be_hide_loading_indicator() throws {
        let (sut, service) = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_load_when_completion_success_should_be_hide_loading_indicator() throws {
        let (sut, service) = try makeSUT()
        
        sut.loadViewIfNeeded()
        
        service.completionResult(.success([.makeItem()]))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_pullToRefresh_should_be_show_loading_indicator() throws {
        let (sut, _) = try makeSUT()
        
        sut.simulatePullToRefresh()
        
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
    }
    
    func test_pullToRefresh_should_be_hide_loading_indicator_when_service_completion_failure() throws {
        let (sut, service) = try makeSUT()
        
        sut.simulatePullToRefresh()
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_show_loading_indicator_for_all_life_cycle_view() throws {
        let (sut, service) = try makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        service.completionResult(.failure(.connectivity))
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
        service.completionResult(.success([.makeItem()]))
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_load_completion_dispatches_in_background_threds() throws {
        let (sut, service) = try makeSUT()
        let items: [RestaurantItem] = [.makeItem()]
        
        sut.loadViewIfNeeded()
        let exp = expectation(description: #function)
        DispatchQueue.global().async {
            service.completionResult(.success(items))
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        XCTAssertTrue(true)
    }
    
    func test_render_all_restaurant_information_in_view() throws {
        let (sut, service) = try makeSUT()
        let restaurantItem: RestaurantItem = .makeItem()
        
        sut.loadViewIfNeeded()
        service.completionResult(.success([restaurantItem]))
        
        XCTAssertEqual(sut.numberOfRows(), 1)
        
        let cell = sut.tableView(sut.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? RestaurantItemCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.title.text, restaurantItem.name)
        XCTAssertEqual(cell?.parasols.text, restaurantItem.parasolsToString)
        XCTAssertEqual(cell?.distance.text, restaurantItem.distanceToString)

    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws ->  (sut: RestaurantListViewController, service: RestaurantLoaderSpy) {
        let service = RestaurantLoaderSpy()
        let sut = try XCTUnwrap(RestaurantListCompose.compose(service: service) as? RestaurantListViewController)
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        
        return (sut, service)
    }
    
}

final class RestaurantLoaderSpy: RestaurantLoaderProtocol {
    
    enum Methods: Equatable {
        case load
    }
    
    private(set) var methodsCalled = [Methods]()
    private var completionLoadHandler: ((RestaurantResult) -> Void)?
    func load(completion: @escaping (RestaurantResult) -> Void) {
        methodsCalled.append(.load)
        completionLoadHandler = completion
    }
    
    func completionResult(_ result: RestaurantResult) {
        completionLoadHandler?(result)
    }
}


private extension RestaurantListViewController {
    
    var isShowLoadingIndicator: Bool {
        return refreshControl?.isRefreshing ?? false
    }
    
    func simulatePullToRefresh() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func numberOfRows() -> Int {
        return tableView.numberOfRows(inSection: 0)
    }
}
