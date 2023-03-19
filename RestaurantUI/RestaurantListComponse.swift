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
        let presenter = RestaurantListPresenter()
        let interactor = RestaurantListInteractor(service: service, presenter: presenter)
        let controller = RestaurantListViewController(interactor: interactor)
        presenter.view = controller
        return controller
    }
}
