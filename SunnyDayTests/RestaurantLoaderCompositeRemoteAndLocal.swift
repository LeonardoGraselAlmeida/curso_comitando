//
//  RestaurantLoaderCompositeRemoteAndLocal.swift
//  RestaurantLoaderCompositeRemoteAndLocal
//
//  Created by Leonardo Almeida on 07/10/2023.
//

import XCTest
import RestaurantDomain
@testable import SunnyDay

internal final class RestaurantLoaderCompositeRemoteAndLocalTestCase: XCTestCase {

    internal func test_load_composite_should_be_completion_success_for_main_loader() {
        let main = RestaurantLoaderSpy()
        let fallback = RestaurantLoaderSpy()
        let sut = RestaurantLoaderCompositeRemoteAndLocal(main: main, fallback: fallback)
        
        sut.load { _ in }
        main.competionResult(.success([.makeItem()]))
        
        XCTAssertEqual(main.methodsCalled, [.load])
        XCTAssertEqual(fallback.methodsCalled, [])
    }
    
    internal func test_load_composite_should_be_completion_success_for_fallback_loader() {
        let main = RestaurantLoaderSpy()
        let fallback = RestaurantLoaderSpy()
        let sut = RestaurantLoaderCompositeRemoteAndLocal(main: main, fallback: fallback)
        
        sut.load { _ in }
        main.competionResult(.failure(.connectivity))
        fallback.competionResult(.success([.makeItem()]))
        
        XCTAssertEqual(main.methodsCalled, [.load])
        XCTAssertEqual(fallback.methodsCalled, [.load])
    }
    
    internal func test_load_composite_should_be_completion_error_when_main_and_fallback_returned_failure() {
        let main = RestaurantLoaderSpy()
        let fallback = RestaurantLoaderSpy()
        let sut = RestaurantLoaderCompositeRemoteAndLocal(main: main, fallback: fallback)
        
        sut.load { _ in }
        main.competionResult(.failure(.connectivity))
        fallback.competionResult(.failure(.connectivity))
        
        XCTAssertEqual(main.methodsCalled, [.load])
        XCTAssertEqual(fallback.methodsCalled, [.load])
    }

}

internal final class RestaurantLoaderSpy: RestaurantLoaderProtocol {
    
    enum Methods: Equatable {
            case load
    }
    
    private(set) var methodsCalled = [Methods]()
    private var completionHandler: ((RestaurantResult) -> Void)?
    
    internal func load(completion: @escaping (RestaurantResult) -> Void) {
        methodsCalled.append(.load)
        completionHandler = completion
    }
    
    internal func competionResult(_ result: RestaurantResult) {
        completionHandler?(result)
    }
}
