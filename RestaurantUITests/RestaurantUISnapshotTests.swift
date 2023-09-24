//
//  RestaurantUISnapshotTests.swift
//  RestaurantUITests
//
//  Created by Leonardo Almeida on 01/04/23.
//

import XCTest
import SnapshotTesting
import RestaurantDomain
@testable import RestaurantUI

final class RestaurantUISnapshotTests: XCTestCase {
    
    func test_snapshot_after_render_restaurantItemCell() {
        let controller = RestaurantItemCellController(model: dataModel[0])
        let cell = RestaurantItemCell(style: .default, reuseIdentifier: RestaurantItemCell.identifier)
        cell.backgroundColor = .white
        controller.setupCell(cell)
        assertSnapshot(matching: cell, as: .image(size: CGSize(width: 375, height: 175)), record: true)
    }
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) ->  (sut: RestaurantListViewController, service: RestaurantLoaderSpy) {
        let service = RestaurantLoaderSpy()
        let sut = RestaurantListComponse.componse(service: service)
         
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(service, file: file, line: line)
        
        return (sut, service)
    }
    
    private let dataModel = [
        RestaurantItem(id: UUID(), name: "Tenda do quartel", location: "Canto do Forte - Praia Grande", distance: 50, ratings: 4, parasols: 10),
        RestaurantItem(id: UUID(), name: "Barraquinha do seu Zé", location: "Canto do Forte - Praia Grande", distance: 100, ratings: 2, parasols: 22),
        RestaurantItem(id: UUID(), name: "Barraquinha do coronal", location: "Canto do Forte - Praia Grande", distance: 150, ratings: 3, parasols: 35),
        RestaurantItem(id: UUID(), name: "Tenda dos soldados", location: "Canto do Forte - Praia Grande", distance: 200, ratings: 4, parasols: 47),
        RestaurantItem(id: UUID(), name: "Tenda do Milico", location: "Canto do Forte - Praia Grande", distance: 250, ratings: 4, parasols: 15)
    ]
}
