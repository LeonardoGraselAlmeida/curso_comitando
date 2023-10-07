//
//  RestaurantLoaderCompositeRemoteAndLocal.swift
//  SunnyDay
//
//  Created by Leonardo Almeida on 07/10/2023.
//

import Foundation
import RestaurantDomain

final class RestaurantLoaderCompositeRemoteAndLocal {
    
    private let main: RestaurantLoaderProtocol
    private let fallback: RestaurantLoaderProtocol
    
    init(main: RestaurantLoaderProtocol, fallback: RestaurantLoaderProtocol) {
        self.main = main
        self.fallback = fallback
    }
}

extension RestaurantLoaderCompositeRemoteAndLocal: RestaurantLoaderProtocol {
    
    func load(completion: @escaping (RestaurantResult) -> Void) {
        main.load { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(items):
                completion(.success(items))
            case .failure:
                self.fallback.load(completion: completion)
            }
        }
    }
}
