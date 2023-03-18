//
//  RestaurantItem.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 12/02/23.
//

import Foundation

public struct RestaurantItem: Codable, Equatable {
    public let id: UUID
    public let name: String
    public let location: String
    public let distance: Float
    public let ratings: Int
    public let parasols: Int
    
    public init(id: UUID, name: String, location: String, distance: Float, ratings: Int, parasols: Int) {
        self.id = id
        self.name = name
        self.location = location
        self.distance = distance
        self.ratings = ratings
        self.parasols = parasols
    }
    
    public var parasolsToString: String {
        return "Guarda-sois: \(parasols)"
    }
    
    public var distanceToString: String {
        return "Distância: \(distance)m"
    }
}
