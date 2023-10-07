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
        let result: RestaurantLoaderProtocol.RestaurantResult = .success([.makeItem()])
        let sut = makeSUT(mainResult: result, fallbackResult: .failure(.connectivity))
        assert(sut, completion: result)
    }
    
    internal func test_load_composite_should_be_completion_success_for_fallback_loader() {
        let result: RestaurantLoaderProtocol.RestaurantResult = .success([.makeItem()])
        let sut = makeSUT(mainResult: .failure(.connectivity), fallbackResult: result)
        assert(sut, completion: result)
    }
    
    internal func test_load_composite_should_be_completion_error_when_main_and_fallback_returned_failure() {
        let result: RestaurantLoaderProtocol.RestaurantResult = .failure(.connectivity)
        let sut = makeSUT(mainResult: .failure(.invalidData), fallbackResult: result)
        assert(sut, completion: result)
    }
    
    private func makeSUT(
        mainResult: RestaurantLoaderProtocol.RestaurantResult,
        fallbackResult: RestaurantLoaderProtocol.RestaurantResult,
        file: StaticString = #file,
        line: UInt = #line
    ) -> RestaurantLoaderProtocol {
        let main = RestaurantLoaderSpy(result: mainResult)
        let fallback = RestaurantLoaderSpy(result: fallbackResult)
        let sut = RestaurantLoaderCompositeRemoteAndLocal(main: main, fallback: fallback)
        
        trackForMemoryLeaks(main)
        trackForMemoryLeaks(fallback)
        trackForMemoryLeaks(sut)
        
        return sut
    }
    
    private func assert(
        _ sut: RestaurantLoaderProtocol,
        completion result: RestaurantLoaderProtocol.RestaurantResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "esperando bloco ser completado")
        sut.load { returnedResult in
            switch (result, returnedResult) {
            case let(.success(resultItems), .success(returnedItems)):
                XCTAssertEqual(resultItems, returnedItems)
            case (.failure,.failure):
                break
            default:
                XCTFail("Esperado \(result), porem retornou \(returnedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
}

internal final class RestaurantLoaderSpy: RestaurantLoaderProtocol {
    
    enum Methods: Equatable {
        case load
    }
    
    private(set) var methodsCalled = [Methods]()
    
    private let result: RestaurantResult
    
    init(result: RestaurantResult) {
        self.result = result
    }
    
    internal func load(completion: @escaping (RestaurantResult) -> Void) {
        methodsCalled.append(.load)
        completion(result)
    }
}
