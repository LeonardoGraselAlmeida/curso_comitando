//
//  Date+Helpers.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 05/03/23.
//

import Foundation

extension Date {
    func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
