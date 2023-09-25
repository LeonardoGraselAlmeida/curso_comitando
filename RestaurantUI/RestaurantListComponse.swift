//
//  RestaurantListComponse.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 18/03/23.
//

import UIKit
import RestaurantDomain

final class RestaurantListComponse {
    
    static func componse(service: RestaurantLoaderProtocol) -> RestaurantListViewController {
        let decorator = MainQueueDispatchDecorator(decoratee: service)
        let presenter = RestaurantListPresenter()
        let interactor = RestaurantListInteractor(service: decorator, presenter: presenter)
        let controller = RestaurantListViewController(interactor: interactor)
        controller.title = "Praia do Forte"
        presenter.view = controller
        return controller
    }
}

extension MainQueueDispatchDecorator: RestaurantLoaderProtocol where T == RestaurantLoaderProtocol {
    
    func load(completion: @escaping (RestaurantResult) -> Void) {
        decoratee.load { [weak self] result in
            guard let self else { return }
            self.dispatch {
                completion(result)
            }
        }
    }
    
}
