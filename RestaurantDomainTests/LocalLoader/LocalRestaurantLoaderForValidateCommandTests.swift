//
//  LocalRestaurantLoaderForValidateCommandTests.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 05/03/23.
//

import XCTest
@testable import RestaurantDomain

final class LocalRestaurantLoaderForValidateCommandTests: XCTestCase {
    
    func test_load_delete_cache_after_error_to_load() {
        let (sut, cache) = makeSUT()
        
        sut.validateCache()
        let anyError = NSError(domain: "any error", code: -1)
        cache.completionHandlerForLoad(.failure(anyError))
        
        XCTAssertEqual(cache.methodsCalled, [.load, .delete])
    }
    
    func test_load_nonDelete_cache_after_empty_result() {
        let (sut, cache) = makeSUT()
        
        sut.validateCache()
        cache.completionHandlerForLoad(.empty)
        
        XCTAssertEqual(cache.methodsCalled, [.load])
    }
    
    func test_load_onDelete_cache_when_one_day_less_than_old_cache() {
        let currentDate = Date()
        let oneDayLessThanOldCacheDate = currentDate.adding(days: -1).adding(seconds: 1)
        let (sut, cache) = makeSUT()
        let items = [RestaurantItem.mock]
        
        sut.validateCache()
        cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayLessThanOldCacheDate))
        
        XCTAssertEqual(cache.methodsCalled, [.load])
    }
    
    func test_load_onDelete_cache_when_one_day_old_cache() {
        let currentDate = Date()
        let oneDayLessThanOldCacheDate = currentDate.adding(days: -1)
        let (sut, cache) = makeSUT()
        let items = [RestaurantItem.mock]
        
        sut.validateCache()
        cache.completionHandlerForLoad(.success(items: items, timestamp: oneDayLessThanOldCacheDate))
        
        XCTAssertEqual(cache.methodsCalled, [.load, .delete])
    }
    
    private func makeSUT(currentDate: Date = Date(), file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRestaurantLoader, cache: CacheClientSpy) {
        let currentDate = Date()
        let cache = CacheClientSpy()
        let sut = LocalRestaurantLoader(cache: cache, currentDate: {currentDate})
        
        trackForMemoryLeaks(cache)
        trackForMemoryLeaks(sut)
        
        return (sut, cache)
    }
}


