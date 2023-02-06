//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 06/02/23.
//

import XCTest
@testable import RestaurantDomain

final class RemoteRestaurantLoaderTests: XCTestCase {
    
    func test_initializer_remoteRemoteRestaurantLoader_and_validate_urlRequest() throws {
        let anyURL = try XCTUnwrap(URL(string: "http://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client )
        
        sut.load { _ in }
        
        XCTAssertEqual(client.urlRequests, [anyURL])
    }
    
    func test_load_twice() throws {
        let anyURL = try XCTUnwrap(URL(string: "http://comitando.com.br"))
        let client = NetworkClientSpy()
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client )
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.urlRequests, [anyURL, anyURL])
    }
    
    func test_load_and_returned_error_for_connectivity() throws {
        let anyURL = try XCTUnwrap(URL(string: "http://comitando.com.br"))
        let client = NetworkClientSpy()
        client.stateHandler = .error(client.anyError())
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client)
        
        let exp = expectation(description: "esperando retorno da clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, .connectivity)
    }
    
    func test_load_and_returned_error_for_invalidData() throws {
        let anyURL = try XCTUnwrap(URL(string: "http://comitando.com.br"))
        let client = NetworkClientSpy()
        client.stateHandler = .success
        let sut = RemoteRestaurantLoader(url: anyURL, networkClient: client )
        
        let exp = expectation(description: "esperando retorno da clousure")
        var returnedResult: RemoteRestaurantLoader.Error?
        sut.load { result in
            returnedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(returnedResult, .invalidData)
    }
}

final class NetworkClientSpy: NetworkClient {
    
    private(set) var urlRequests: [URL?] = []
    var stateHandler: NetworkState?
    
    func request(from url: URL, completion: @escaping (NetworkState) -> Void) {
        urlRequests.append(url)
        completion(stateHandler ?? .error(anyError()))
    }
    
    fileprivate func anyError() -> Error {
        return NSError(domain: "any error", code: 1)
    }
}
