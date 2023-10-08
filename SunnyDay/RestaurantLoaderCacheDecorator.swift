//
//  RestaurantLoaderCacheDecorator.swift
//  SunnyDay
//
//  Created by Leonardo Almeida on 07/10/2023.
//

import Foundation
import RestaurantDomain

final class RestaurantLoaderCacheDecorator {
    
    private let decoratee: RestaurantLoaderProtocol
    private let cache: LocalRestaurantLoaderInsert
    
    init(decoratee: RestaurantLoaderProtocol, cache: LocalRestaurantLoaderInsert) {
        self.decoratee = decoratee
        self.cache = cache
    }
}

extension RestaurantLoaderCacheDecorator: RestaurantLoaderProtocol {
    
    func load(completion: @escaping (RestaurantResult) -> Void) {
        decoratee.load { [weak self] result in
            completion ( result.map({ items in
                self?.cache.save(items) { _ in }
                return items
            }))
        }
    }
    
}
