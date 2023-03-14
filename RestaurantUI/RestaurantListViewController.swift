//
//  RestaurantListViewController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 13/03/23.
//

import UIKit
import RestaurantDomain

final class RestaurantListViewController: UIViewController {
    
    private(set) var restaurantCollection: [RestaurantItem] = []
    private var service: RestaurantLoaderProtocol?
    
    convenience init(service: RestaurantLoaderProtocol) {
        self.init()
        self.service = service
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service?.load { result in
            switch result {
            case let .success(items):
                self.restaurantCollection = items
            default: break
            }
        }
    }
}
