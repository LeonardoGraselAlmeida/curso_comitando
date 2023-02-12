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
        let currentDate = Date()
        let cache = CacheClientSpy()
        let sut = LocalRestaurantLoader(cache: cache, currentDate: {currentDate})
        let items: [RestaurantItem] = [RestaurantItem(id: UUID(), name: "name", location: "location", distance: 5.5, ratings: 0, parasols: 0)]
        
        sut.save(items) {_ in }
        
        XCTAssertEqual(cache.deleteCount, 1)
    }
}

final class CacheClientSpy: CacheClient {
    func save(_ items: [RestaurantDomain.RestaurantItem], timestamp: Date, completion: (Error?) -> Void) {
        
    }
    
    private(set) var deleteCount = 0
    func delete(completion: @escaping (Error?) -> Void) {
        deleteCount += 1
    }
    
    
}
