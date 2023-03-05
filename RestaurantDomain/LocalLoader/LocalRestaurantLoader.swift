//
//  LocalRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 12/02/23.
//

import Foundation

public enum LoadResultState {
    case empty
    case success(items: [RestaurantItem], timestamp: Date)
    case failure(Error)
}

public protocol CacheClient {
    typealias SaveResult = (Error?) -> Void
    typealias DeleteResult = (Error?) -> Void
    typealias LoadResult = (LoadResultState) -> Void
    
    func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult)
    func delete(completion: @escaping DeleteResult)
    func load(completion: @escaping LoadResult)
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

extension LocalRestaurantLoader: RestaurantLoader {
    
    private func validate(_ timestamp: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        guard let maxAge = calendar.date(byAdding: .day, value: 1, to: timestamp) else {
            return false
        }
        return currentDate() < maxAge
    }
    
    
    public func load(completion: @escaping (RemoteRestaurantResult) -> Void) {
        cache.load { [weak self] state in
            guard let self else { return }
            switch state {
            case let .success(items, timestamp) where self.validate(timestamp):
                completion(.success(items))
            case .success:
                self.cache.delete {_ in }
                completion(.success([]))
            case .empty:
                completion(.success([]))
            case .failure:
                self.cache.delete {_ in }
                completion(.failure(.invalidData))
            }
        }
    }
}
