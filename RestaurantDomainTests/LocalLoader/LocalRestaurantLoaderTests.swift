//
//  LocalRestaurantLoaderTests.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 12/02/23.
//

import XCTest
@testable import RestaurantDomain

final class LocalRestaurantLoaderTests: XCTestCase {
    
    func test_save_deletes_old_cache() {
        let (sut, cache) = makeSUT()
        let items: [RestaurantItem] = [makeItem()]
        
        sut.save(items) {_ in }
        
        XCTAssertEqual(cache.methodsCalled, [.delete])
    }
    
    func test_save_insert_new_data_on_cache() {
        let currentDate = Date()
        let (sut, cache) = makeSUT(currentDate: currentDate)
        let items: [RestaurantItem] = [makeItem()]
        
        sut.save(items) {_ in }
        cache.completionHandlerForDelete(nil)
        
        XCTAssertEqual(cache.methodsCalled, [.delete, .save(items: items, timestamp: currentDate)])
    }
    
    func test_save_fails_after_delete_old_cache() {
        let (sut, cache) = makeSUT()
        let items: [RestaurantItem] = [makeItem()]
        
        var returnedError: Error?
        sut.save(items) { error in
            returnedError = error
        }
        
        let anyError = NSError(domain: "any error", code: -1)
        cache.completionHandlerForDelete(anyError)
        
        XCTAssertEqual(returnedError as? NSError, anyError)
    }
    
    func test_save_fails_after_insert_new_data_cache() {
        let (sut, cache) = makeSUT()
        let items: [RestaurantItem] = [makeItem()]
        
        var returnedError: Error?
        sut.save(items) { error in
            returnedError = error
        }
        
        let anyError = NSError(domain: "any error", code: -1)
        cache.completionHandlerForDelete(nil)
        cache.completionHandlerForInsert(anyError)
        
        XCTAssertEqual(returnedError as? NSError, anyError)
    }
    
    private func makeSUT(currentDate: Date = Date(), file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalRestaurantLoader, cache: CacheClientSpy) {
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

final class CacheClientSpy: CacheClient {
    
    enum Methods: Equatable {
        case delete
        case save(items: [RestaurantItem], timestamp: Date)
    }
    
    private(set) var methodsCalled = [Methods]()
    
    func save(_ items: [RestaurantDomain.RestaurantItem], timestamp: Date, completion: (Error?) -> Void) {
        methodsCalled.append(.save(items: items, timestamp: timestamp))
    }
    
    private var completionHandler: ((Error?) -> Void)?
    func delete(completion: @escaping (Error?) -> Void) {
        methodsCalled.append(.delete)
        completionHandler = completion
    }
    
    func completionHandlerForDelete(_ error: Error?) {
        completionHandler?(error)
    }
    
    func completionHandlerForInsert(_ error: Error?) {
        completionHandler?(error)
    }
}
