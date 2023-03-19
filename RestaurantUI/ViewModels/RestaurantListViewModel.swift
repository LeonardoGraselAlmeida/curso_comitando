//
//  RestaurantListViewModel.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 19/03/23.
//

import Foundation
import RestaurantDomain

final class RestaurantListViewModel {
    
    private let service: RestaurantLoaderProtocol
    
    var onLoadingState: ((Bool) -> Void)?
    var onRestaurantItem: (([RestaurantItem]) -> Void)?
    
    init(service: RestaurantLoaderProtocol) {
        self.service = service
    }
    
    func loadService() {
        onLoadingState?(true)
        service.load { [weak self] result in
            switch result {
            case let .success(items):
                self?.onRestaurantItem?(items)
            default: break
            }
            self?.onLoadingState?(false)
        }
    }
}
