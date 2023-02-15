//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 06/02/23.
//

import Foundation

struct RestaurantRoot: Decodable {
    let items: [RestaurantItem]
}

public final class RemoteRestaurantLoader {
    
    let url: URL
    let networkClient: NetworkClient
    private let okResponse: Int = 200
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    private func successFullyValidation(_ data: Data, response: HTTPURLResponse) -> RemoteRestaurantResult {
        guard let json = try? JSONDecoder().decode(RestaurantRoot.self, from: data), response.statusCode == okResponse else {
            return .failure(.invalidData)
        }
        
        return .success(json.items)
    }
    
    public typealias RemoteRestaurantResult = Result<[RestaurantItem], Error>
    
    public func load(completion: @escaping (RemoteRestaurantLoader.RemoteRestaurantResult) -> Void) {
        networkClient.request(from: url) { [weak self] result in
            guard let self else { return }
            switch(result) {
            case let .success((data, response)): completion(self.successFullyValidation(data, response: response))
            case .failure: completion(.failure(.connectivity))
            }
        }
    }
}
