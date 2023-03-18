//
//  RestaurantListViewController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 13/03/23.
//

import UIKit
import RestaurantDomain

final class RestaurantListViewController: UITableViewController {
    
    private(set) var restaurantCollection: [RestaurantItem] = []
    private var service: RestaurantLoaderProtocol?
    
    convenience init(service: RestaurantLoaderProtocol) {
        self.init()
        self.service = service
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        loadService()
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(loadService), for: .valueChanged)
    }
    
    @objc func loadService() {
        refreshControl?.beginRefreshing()
        service?.load { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(items):
                self.restaurantCollection = items
            default: break
            }
            
            self.refreshControl?.endRefreshing()
        }
    }
} 
