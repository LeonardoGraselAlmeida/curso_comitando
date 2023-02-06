//
//  RestaurantDomainTests.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 06/02/23.
//

import XCTest
@testable import RestaurantDomain

final class RestaurantDomainTests: XCTestCase {

    func test_initializer_remoteRemoteRestaurantLoader_and_validate_urlRequest() throws {
        let anyURL = try XCTUnwrap(URL(string: "http://comitando.com.br"))
        let sut = RemoteRestaurantLoader(url: anyURL)
        
        sut.load()
        
        XCTAssertNotNil(NetworkClient.shared.urlRequest )
    }
}
 
