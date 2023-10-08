//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 12/02/23.
//

import Foundation

public protocol LocalRestaurantLoaderInsert {
    func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void)
}

public final class LocalRestaurantLoader {
    
    private let cache: CacheClientProtocol
    private let cachePolicy: CachePolicyProtocol
    private let currentDate: () -> Date
    
    public init(cache: CacheClientProtocol,
                cachePolicy: CachePolicyProtocol = RestaurantLoaderCachePolicy(),
                currentDate: @escaping () -> Date) {
        self.cache = cache
        self.currentDate = currentDate
        self.cachePolicy = cachePolicy
    }
    
    private func saveOnCache(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        self.cache.save(items, timestamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func validateCache() {
        cache.load { [weak self] state in
            guard let self else { return }
            switch state {
            case let .success(_, timestamp) where !self.cachePolicy.validate(timestamp, with: self.currentDate()):
                self.cache.delete {_ in }
            case .failure:
                self.cache.delete {_ in }
            default: break
            }
        }
    }
}

extension LocalRestaurantLoader: LocalRestaurantLoaderInsert {
    
    public func save(_ items: [RestaurantItem], completion: @escaping (Error?) -> Void) {
        cache.delete { [weak self] error in
            guard let self else { return }
            guard let error else {
                return self.saveOnCache(items, completion: completion)
            }
            completion(error)
            
        }
    }
    
}

extension LocalRestaurantLoader: RestaurantLoaderProtocol {
    
    public func load(completion: @escaping (RestaurantResult) -> Void) {
        cache.load { [weak self] state in
            guard let self else { return }
            switch state {
            case let .success(items, timestamp) where self.cachePolicy.validate(timestamp, with: self.currentDate()):
                completion(.success(items))
            case .success, .empty:
                completion(.success([]))
            case .failure:
                completion(.failure(.invalidData))
            }
        }
    }
    
}
