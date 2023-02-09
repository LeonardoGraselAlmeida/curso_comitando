//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 06/02/23.
//

import Foundation

struct RestaurantItem {
    let id: UUID
    let name: String
    let location: String
    let distance: Float
    let ratings: Int
    let parasols: Int
}

protocol NetworkClient {
    typealias NetworkState = Result<(Data, HTTPURLResponse), Error>
    func request(from url: URL, completion: @escaping (NetworkState) -> Void)
}


final class RemoteRestaurantLoader {
    
    let url: URL
    let networkClient: NetworkClient
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    init(url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    func load(completion: @escaping (RemoteRestaurantLoader.Error) -> Void) {
        networkClient.request(from: url) { result in
            switch(result) {
            case .success: completion(.invalidData)
            case .failure: completion(.connectivity)
            }
        }
    }
}
