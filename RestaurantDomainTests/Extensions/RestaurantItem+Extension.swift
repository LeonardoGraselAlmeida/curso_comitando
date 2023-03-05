//
//  RestaurantITem+Extension.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 05/03/23.
//

@testable import RestaurantDomain

extension RestaurantItem {
    static let mock: Self = .init(id: UUID(), name: "name", location: "location", distance: 5.5, ratings: 0, parasols: 0)
}

