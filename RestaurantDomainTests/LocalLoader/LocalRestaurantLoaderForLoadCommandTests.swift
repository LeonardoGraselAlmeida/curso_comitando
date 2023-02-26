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
        cache.completionHandlerForLoad(anyError)
        
        XCTAssertEqual(cache.methodsCalled, [.load])
        XCTAssertEqual(returnResult, .failure(.invalidData))
    }
    
    func test_load_returned_completion_success_with_empty_data() {
        let (sut, cache) = makeSUT()
        
        var returnResult: RestaurantLoader.RemoteRestaurantResult?
        sut.load { result in
            returnResult = result
        }
        
        cache.completionHandlerForLoad(nil)
        
        XCTAssertEqual(cache.methodsCalled, [.load])
        XCTAssertEqual(returnResult, .success([]))
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
}

