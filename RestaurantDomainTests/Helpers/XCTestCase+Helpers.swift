//
//  XCTestCase+Helpers.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 12/02/23.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "A Instancia deveteria ter sido desalocada, possível vazamento de memória.", file: file, line: line)
        }
    }
}
