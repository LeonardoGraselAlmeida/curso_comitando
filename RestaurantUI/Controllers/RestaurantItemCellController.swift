//
//  RestaurantItemCellController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 18/03/23.
//

import UIKit
import RestaurantDomain

final class RestaurantItemCellController {
    
    let model: RestaurantItem
    
    init(model: RestaurantItem) {
        self.model = model
    }
    
    func setupCell(_ cell: RestaurantItemCell) {
        cell.title.text = model.name
        cell.location.text = model.location
        cell.distance.text = model.distanceToString
        cell.parasols.text = model.parasolsToString
        cell.collectionOfRating.enumerated().forEach { (index, image) in
            let systemName = index < model.ratings ? "start.fill" : "star"
            image.image = UIImage(systemName: systemName)
        }
    }
}
