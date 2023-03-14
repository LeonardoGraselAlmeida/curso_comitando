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
    
    func test_init_does_not_load() {
        let (sut, service) = makeSUT()
        
        XCTAssertTrue(service.methodsCalled.isEmpty)
        XCTAssertTrue(sut.restaurantCollection.isEmpty)
    }
    
    func test_viewDidLoad_should_be_called_load_service() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.methodsCalled, [.load])
    }
    
    func test_load_returned_restaurantItems_data_and_restaurantCollection_does_not_empty() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionResult(.success([RestaurantItem.makeItem()]))
        
        XCTAssertEqual(service.methodsCalled, [.load])
        XCTAssertEqual(sut.restaurantCollection.count, 1)
    }
    
    func test_load_returned_error_and_restaurantCollection_is_empty() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(service.methodsCalled, [.load])
        XCTAssertEqual(sut.restaurantCollection.count, 0)
    }
    
    func test_pullToRefresh_should_be_called_load_service() {
        let (sut, service) = makeSUT()
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load])
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load, .load])
        
        sut.simulatePullToRefresh()
        XCTAssertEqual(service.methodsCalled, [.load, .load, .load, .load])
    }
    
    func test_viewDidLoad_show_loading_indicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
    }
    
    func test_load_when_completion_failure_should_be_hide_loading_indicator() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_load_when_completion_success_should_be_hide_loading_indicator() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        service.completionResult(.success([.makeItem()]))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    func test_pullToRefresh_should_be_show_loading_indicator() {
        let (sut, _) = makeSUT()
        
        sut.simulatePullToRefresh()
        
        XCTAssertEqual(sut.isShowLoadingIndicator, true)
    }
    
    func test_pullToRefresh_should_be_hide_loading_indicator_when_service_completion_failure(){
        let (sut, service) = makeSUT()
        
        sut.simulatePullToRefresh()
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(sut.isShowLoadingIndicator, false)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) ->  (sut: RestaurantListViewController, service: RestaurantLoaderSpy) {
        let service = RestaurantLoaderSpy()
        let sut = RestaurantListViewController(service: service)
        
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
    
    func simulatePullToRefresh() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowLoadingIndicator: Bool {
        return refreshControl?.isRefreshing ?? false
    }
}
