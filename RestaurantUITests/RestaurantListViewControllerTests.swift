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
        let (_, service) = makeSUT()
        
        XCTAssertEqual(service.loadCount, 0)
    }
    
    func test_viewDidLoad_should_be_called_load_service() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(service.loadCount, 1)
    }
    
    func test_load_returned_restaurantItems_data_and_restaurantCollection_does_not_empty() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionResult(.success([RestaurantItem.makeItem()]))
        
        XCTAssertEqual(service.loadCount, 1)
        XCTAssertEqual(sut.restaurantCollection.count, 1)
    }
    
    func test_load_returned_error_and_restaurantCollection_is_empty() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(service.loadCount, 1)
        XCTAssertEqual(sut.restaurantCollection.count, 0)
    }
    
    func test_pullToRefresh_should_be_called_load_service() {
        let (sut, service) = makeSUT()
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(service.loadCount, 2)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(service.loadCount, 3)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(service.loadCount, 4)
    }
    
    func test_viewDidLoad_show_loading_indicator() {
        let (sut, _) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    func test_load_when_completion_failure_should_be_hide_loading_indicator() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    func test_load_when_completion_success_should_be_hide_loading_indicator() {
        let (sut, service) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        service.completionResult(.success([.makeItem()]))
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
    }
    
    func test_pullToRefresh_should_be_show_loading_indicator() {
        let (sut, _) = makeSUT()
        
        sut.refreshControl?.simulatePullToRefresh()
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, true)
    }
    
    func test_pullToRefresh_should_be_hide_loading_indicator_when_service_completion_failure(){
        let (sut, service) = makeSUT()
        
        sut.refreshControl?.simulatePullToRefresh()
        service.completionResult(.failure(.connectivity))
        
        XCTAssertEqual(sut.refreshControl?.isRefreshing, false)
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
    private(set) var loadCount = 0
    private var completionLoadHandler: ((RestaurantResult) -> Void)?
    func load(completion: @escaping (RestaurantResult) -> Void) {
        loadCount += 1
        completionLoadHandler = completion
    }
    
    func completionResult(_ result: RestaurantResult) {
        completionLoadHandler?(result)
    }
}
