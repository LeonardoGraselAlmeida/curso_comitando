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
        let refreshController = RefreshController(service: service)
        let controller = RestaurantListViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptRestaurantItemToCellController(controller: controller)
        
        return controller
    }
    
    static func adaptRestaurantItemToCellController(controller: RestaurantListViewController) -> ([RestaurantItem]) -> Void {
        return { [weak controller] items in
            controller?.restaurantCollection = items.map { RestaurantItemCellController(model: $0) }
        }
    }
}
