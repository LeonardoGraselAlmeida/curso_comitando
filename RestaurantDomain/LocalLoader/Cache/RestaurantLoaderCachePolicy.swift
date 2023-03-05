//
//  s.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 05/03/23.
//

import Foundation

public final class RestaurantLoaderCachePolicy: CachePolicy {
    
    private let maxAge: Int = 1
    
    public init() {}
    
    public func validate(_ timestamp: Date, with currentDate: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        guard let maxAge = calendar.date(byAdding: .day, value: maxAge, to: timestamp) else {
            return false
        }
        return currentDate < maxAge
    }
}
