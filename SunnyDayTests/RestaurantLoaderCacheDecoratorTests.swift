//
//  Decoretor.swift
//  SunnyDayTests
//
//  Created by Leonardo Almeida on 08/10/2023.
//

import XCTest
import RestaurantDomain
@testable import SunnyDay

final class RestaurantLoaderCacheDecoratorTests: XCTestCase {
    
    func test_decoratee_load_should_be_completion_success() {
        let items: [RestaurantItem] = [.makeItem()]
        let result: RestaurantLoaderProtocol.RestaurantResult = .success(items)
        let (sut, _) = makeSUT(result: result)
        
        assert(sut, completion: result)
    }
    
    func test_decoratee_load_should_be_completion_error() {
        let result: RestaurantLoaderProtocol.RestaurantResult = .failure(.connectivity)
        let (sut, _) = makeSUT(result: result)
        
        assert(sut, completion: result)
    }
    
    func test_cache_insert_after_load_returned_success() {
        let items: [RestaurantItem] = [.makeItem()]
        let result: RestaurantLoaderProtocol.RestaurantResult = .success(items)
        let (sut, cache) = makeSUT(result: result)
        
        sut.load { _ in }
        
        XCTAssertEqual(cache.methodsCalled, [.save(items)])
    }
    
    func test_cache_no_insert_after_load_returned_failure() {
        let result: RestaurantLoaderProtocol.RestaurantResult = .failure(.connectivity)
        let (sut, cache) = makeSUT(result: result)
        
        sut.load { _ in }
        
        XCTAssertTrue(cache.methodsCalled.isEmpty)
    }
    
    private func makeSUT(
        result: RestaurantLoaderProtocol.RestaurantResult,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RestaurantLoaderCacheDecorator, cache: LocalRestaurantLoaderInsertSpy) {
        let cache = LocalRestaurantLoaderInsertSpy()
        let service = RestaurantLoaderSpy(result: result)
        let sut = RestaurantLoaderCacheDecorator(decoratee: service, cache: cache)
        trackForMemoryLeaks(service)
        trackForMemoryLeaks(sut)
        return (sut, cache)
    }
    
    private func assert(
        _ sut: RestaurantLoaderCacheDecorator,
        completion result: RestaurantLoaderProtocol.RestaurantResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        
        let exp = expectation(description: "esperando bloco ser completado")
        sut.load { returnedResult in
            switch (result, returnedResult) {
            case let (.success(resultItems), .success(returnedItems)):
                XCTAssertEqual(resultItems, returnedItems, file: file, line: line)
            case (.failure, .failure):
                break
            default: XCTFail("Esperado \(result), porem retornou \(returnedResult)", file: file, line: line)
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

final class LocalRestaurantLoaderInsertSpy: LocalRestaurantLoaderInsert {
    
    enum Methods: Equatable {
        case save([RestaurantItem])
    }
    
    private(set) var methodsCalled = [Methods]()
    private var completionHanlder: ((Error?) -> Void)?
    func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        methodsCalled.append(.save(items))
        completionHanlder = completion
    }
    
    func completionResult(_ error: Error?) {
        completionHanlder?(error)
    }
}
