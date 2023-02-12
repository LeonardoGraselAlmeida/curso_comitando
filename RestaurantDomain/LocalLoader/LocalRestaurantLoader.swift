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
    
    func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping (Error?) -> Void) {
        cache.delete { [unowned self] error in
            if error == nil {
                self.cache.save(items, timestamp: self.currentDate(), completion: completion)
            } else {
                completion(error)
            }
        }
    }
}
