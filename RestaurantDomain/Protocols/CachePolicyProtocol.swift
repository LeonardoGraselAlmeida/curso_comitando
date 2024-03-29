//
//  CachePolicy.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 05/03/23.
//

import Foundation

public protocol CachePolicyProtocol {
    func validate(_ timestamp: Date, with currentDate: Date) -> Bool
}
