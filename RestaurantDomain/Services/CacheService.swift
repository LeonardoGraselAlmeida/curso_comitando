//
//  CacheClient.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 05/03/23.
//

import Foundation

public final class CacheService: CacheClientProtocol {
    
    private let managerURL: URL
    private let callbackQueue = DispatchQueue(label: "\(CacheService.self).CallbackQueue", qos: .userInitiated, attributes: .concurrent)
    
    private struct Cache: Codable {
        let items: [RestaurantItem]
        let timestamp: Date
    }
    
    public init(managerURL: URL) {
        self.managerURL = managerURL
    }
    
    public func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult) {
        let managerURL = self.managerURL
        callbackQueue.async(flags: .barrier) {
            do {
                let cache = Cache(items: items, timestamp: timestamp)
                let enconder = JSONEncoder()
                guard let encoded = try? enconder.encode(cache) else { return }
                try encoded.write(to: managerURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func delete(completion: @escaping DeleteResult) {
        let managerURL = self.managerURL
        callbackQueue.async {
            guard FileManager.default.fileExists(atPath: managerURL.path) else {
                return completion(nil)
            }
            
            do {
                try FileManager.default.removeItem(at: managerURL)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func load(completion: @escaping LoadResult) {
        let managerURL = self.managerURL
        callbackQueue.async {
            guard let data = try? Data(contentsOf: managerURL) else {
                return completion(.empty)
            }
            do {
                let decoder = JSONDecoder()
                let cache = try decoder.decode(Cache.self, from: data)
                completion(.success(items: cache.items, timestamp: cache.timestamp))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
