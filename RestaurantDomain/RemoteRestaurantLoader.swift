//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 06/02/23.
//

import Foundation

protocol NetworkClient {
    func request(from url: URL, completion: @escaping (Error) -> Void)
}

final class RemoteRestaurantLoader {
    
    let url: URL
    let networkClient: NetworkClient
    
    init(url: URL, networkClient: NetworkClient) {
        self.url = url
        self.networkClient = networkClient
    }
    
    func load(completion: @escaping (Error) -> Void) {
        networkClient.request(from: url) { error in
            completion(error)
        }
    }
}
