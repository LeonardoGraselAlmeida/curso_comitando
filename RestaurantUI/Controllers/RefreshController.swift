//
//  RefreshController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 18/03/23.
//

import UIKit
import RestaurantDomain

final class RefreshController: NSObject {
    
    private(set) lazy var view: UIRefreshControl = {
        var refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private let service: RestaurantLoaderProtocol
    
    init(service: RestaurantLoaderProtocol) {
        self.service = service
    }
    
    var onRefresh: (([RestaurantItem]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        service.load { [weak self] result in
            
            switch result {
            case let .success(items):
                self?.onRefresh?(items)
            default: break
            }
            
            self?.view.endRefreshing()
        }
    }
}
