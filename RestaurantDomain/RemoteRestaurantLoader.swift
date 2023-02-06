//
//  RemoteRestaurantLoader.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 06/02/23.
//

import Foundation

final class NetworkClient {
    
    static var shared: NetworkClient = NetworkClient()
    
    private(set) var urlRequest: URL?
    
    private init() {}
    
    func request(from url: URL) {
        urlRequest = url
    }
}

final class RemoteRestaurantLoader {
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func load() {
        NetworkClient.shared.request(from: url)
    }
}
