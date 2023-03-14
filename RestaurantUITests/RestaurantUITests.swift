//
//  RestaurantUITests.swift
//  RestaurantUITests
//
//  Created by Leonardo Almeida on 13/03/23.
//

import XCTest
import RestaurantDomain
@testable import RestaurantUI

final class RestaurantUITests: XCTestCase {

    func test_init_does_not_load() {
        let service = RestaurantLoaderSpy()
        let sut = RestaurantListViewController(service: service)
        
        XCTAssertEqual(sut.restaurantCollection.count, 0)
        XCTAssertEqual(service.loadCount, 0)
    }
    
    func test_viewDidLoad_should_be_called_load_service() {
        let service = RestaurantLoaderSpy()
        let sut = RestaurantListViewController(service: service)
        
        sut.loadViewIfNeeded()
          
        XCTAssertEqual(service.loadCount, 1)
    }

}

final class RestaurantLoaderSpy: RestaurantLoaderProtocol {
    private(set) var loadCount = 0
    func load(completion: @escaping (RemoteRestaurantResult) -> Void) {
        loadCount += 1
    }

}
