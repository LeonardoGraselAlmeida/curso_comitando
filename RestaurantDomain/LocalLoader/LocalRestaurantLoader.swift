//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 12/02/23.
//

import Foundation

protocol CacheClient {
    func save(_ items: [RestaurantItem], timestamp: Date, completion: (Error?) -> Void)
    func delete(completion: @escaping (Error?) -> Void)
}

final class LocalRestaurantLoader {
    
    let cache: CacheClient
    let currentDate: () -> Date
    
    init(cache: CacheClient, currentDate: @escaping () -> Date) {
        self.cache = cache
        self.currentDate = currentDate
    }
    
    func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        cache.delete { [weak self] error in
            guard let self else { return }
            guard let error else {
                return self.saveOnCache(items, completion: completion)
            }
            completion(error)
            
        }
    }
    
    private func saveOnCache(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        self.cache.save(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
