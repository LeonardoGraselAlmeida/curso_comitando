//
//  CacheClient.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 05/03/23.
//

import Foundation

final class CacheClient: CacheClientProtocol {
    
    let managerURL: URL
    
    private struct Cache: Codable {
        let items: [RestaurantItem]
        let timestamp: Date
    }
    
    init(managerURL: URL) {
        self.managerURL = managerURL
    }
    
    func save(_ items: [RestaurantItem], timestamp: Date, completion: @escaping SaveResult) {
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
    
    func delete(completion: @escaping DeleteResult) {
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
    
    func load(completion: @escaping LoadResult) {
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

