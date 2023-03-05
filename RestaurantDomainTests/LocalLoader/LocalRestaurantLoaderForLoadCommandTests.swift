//
//  LocalRestaurantLoaderForLoadCommandTests.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 26/02/23.
//

import XCTest
@testable import RestaurantDomain

class LocalRestaurantLoaderForLoadCommandTests: XCTestCase {
    
    func test_load_returned_completion_error() {
        let (sut, cache) = makeSUT()
        
        var returnResult: RestaurantLoader.RemoteRestaurantResult?
        sut.load { result in
            returnResult = result
        }
        
        let anyError = NSError(domain: "any error", code: -1)
        cache.completionHandlerForLoad(.failure(anyError))
        
        XCTAssertEqual(returnResult, .failure(.invalidData))
    }
    
    func test_load_returned_completion_success_with_empty_data() {
        let currentDate = Date()
        let (sut, cache) = makeSUT(currentDate: currentDate)
        let items = [makeItem()]
        
        assert(sut, completion: .success(items)) {
            cache.completionHandlerForLoad(.success(items: items, timestamp: currentDate))
        }
    }
    
    func test_load_returned_data_with_one_day_less_than_old_cache() {
        let currentDate = Date()
        let oneDayLessThanOldCacheDate = currentDate.adding(days: -1).adding(seconds: 1)
        let (sut, cache) = makeSUT()
        let items = [makeItem()]
        
        assert(sut, completion: .success(items)) {
            cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayLessThanOldCacheDate))
        }
    }
    
    func test_load_returned_data_with_one_day_old_cache() {
        let currentDate = Date()
        let oneDayOldCacheDate = currentDate.adding(days: -1)
        let (sut, cache) = makeSUT()
        let items = [makeItem()]
        
        assert(sut, completion: .success([])) {
            cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayOldCacheDate))
        }
    }
    
    func test_load_delete_cache_after_error_to_load() {
        let (sut, cache) = makeSUT()
        
        sut.load { _ in }
        let anyError = NSError(domain: "any error", code: -1)
        cache.completionHandlerForLoad(.failure(anyError))
        
        XCTAssertEqual(cache.methodsCalled, [.load, .delete])
    }
    
    func test_load_nonDelete_cache_after_empty_result() {
        let (sut, cache) = makeSUT()
        
        sut.load { _ in }
        cache.completionHandlerForLoad(.empty)
        
        XCTAssertEqual(cache.methodsCalled, [.load])
    }
    
    func test_load_onDelete_cache_when_one_day_less_than_old_cache() {
        let currentDate = Date()
        let oneDayLessThanOldCacheDate = currentDate.adding(days: -1).adding(seconds: 1)
        let (sut, cache) = makeSUT()
        let items = [makeItem()]
        
        sut.load { _ in }
        cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayLessThanOldCacheDate))
        
        XCTAssertEqual(cache.methodsCalled, [.load])
    }
    
    func test_load_onDelete_cache_when_one_day_old_cache() {
        let currentDate = Date()
        let oneDayLessThanOldCacheDate = currentDate.adding(days: -1)
        let (sut, cache) = makeSUT()
        let items = [makeItem()]
        
        sut.load { _ in }
        cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayLessThanOldCacheDate))
        
        XCTAssertEqual(cache.methodsCalled, [.load, .delete])
    }

    
    private func makeSUT(currentDate: Date = Date(),
                         file: StaticString = #filePath,
                         line: UInt = #line) -> (sut: LocalRestaurantLoader, cache: CacheClientSpy) {
        let currentDate = Date()
        let cache = CacheClientSpy()
        let sut = LocalRestaurantLoader(cache: cache, currentDate: {currentDate})
        
        trackForMemoryLeaks(cache)
        trackForMemoryLeaks(sut)
        
        return (sut, cache)
    }
    
    private func makeItem() -> RestaurantItem {
        return RestaurantItem(id: UUID(), name: "name", location: "location", distance: 5.5, ratings: 0, parasols: 0)
    }
    
    private func assert(
        _ sut: LocalRestaurantLoader,
        completion result: RestaurantLoader.RemoteRestaurantResult?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var returnResult: RestaurantLoader.RemoteRestaurantResult?
        sut.load { result in
            returnResult = result
        }
        
        action()
        
        XCTAssertEqual(returnResult, result)
    }
}

