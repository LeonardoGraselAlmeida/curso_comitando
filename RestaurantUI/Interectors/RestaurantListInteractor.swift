//
//  RestaurantListInteractor.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 19/03/23.
//

import Foundation
import RestaurantDomain

protocol RestaurantListInteractorInput: AnyObject {
    func loadService()
}

final class RestaurantListInteractor: RestaurantListInteractorInput {
    
    private let service: RestaurantLoaderProtocol
    private let presenter: RestaurantListPresenterInput
    
    init(service: RestaurantLoaderProtocol, presenter: RestaurantListPresenterInput) {
        self.service = service
        self.presenter = presenter
    }
    
    func loadService() {
        presenter.onLoadingChange(true)
        service.load { [weak presenter] result in
            switch result {
            case let .success(items):
                presenter?.onRestaurantItem(items)
            default: break
            }
            presenter?.onLoadingChange(false)
        }
    }
}
