//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 12/02/23.
//

import Foundation

public protocol CacheClient {
    typealias SaveResult = (Error?) -> Void
    typealias DeleteResult = (Error?) -> Void
    func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult)
    func delete(completion: @escaping DeleteResult)
}

public final class LocalRestaurantLoader {
    
    let cache: CacheClient
    let currentDate: () -> Date
    
    public init(cache: CacheClient, currentDate: @escaping () -> Date) {
        self.cache = cache
        self.currentDate = currentDate
    }
    
    public func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
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
