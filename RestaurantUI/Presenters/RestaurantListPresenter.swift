//
//  RestaurantListPresenter.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 19/03/23.
//

import Foundation
import RestaurantDomain

protocol RestaurantListPresenterInput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onRestaurantItem(_ items: [RestaurantItem])
}

protocol RestaurantListPresenterOutput: AnyObject {
    func onLoadingChange(_ isLoading: Bool)
    func onRestaurantItemCell(_ items: [RestaurantItemCellController])
}

final class RestaurantListPresenter: RestaurantListPresenterInput {
    
    weak var view: RestaurantListPresenterOutput?
    
    func onLoadingChange(_ isLoading: Bool) {
        view?.onLoadingChange(isLoading)
    }
    
    func onRestaurantItem(_ items: [RestaurantItem]) {
        view?.onRestaurantItemCell(adaptRestaurantItemToCellController(items))
    }
    
    private func adaptRestaurantItemToCellController(_ items: [RestaurantItem]) -> [RestaurantItemCellController] {
            return items.map { RestaurantItemCellController(model: $0) }
    }
}
