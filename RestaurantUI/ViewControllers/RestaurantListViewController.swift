//
//  RestaurantListViewController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 13/03/23.
//

import UIKit

final class RestaurantListViewController: UITableViewController {
    
    private(set) var restaurantCollection: [RestaurantItemCellController] = []
    
    private var interactor: RestaurantListInteractorInput?
    
    convenience init(interactor: RestaurantListInteractorInput) {
        self.init()
        self.interactor = interactor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(RestaurantItemCell.self, forCellReuseIdentifier: RestaurantItemCell.identifier)
        refresh()
    }
    
    @objc func refresh() {
        interactor?.loadService()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantItemCell.identifier, for: indexPath) as? RestaurantItemCell else { return UITableViewCell() }
        let cellController = restaurantCollection[indexPath.row]
        cellController.setupCell(cell)
        
        return cell
    }
}

extension RestaurantListViewController: RestaurantListPresenterOutput {
    func onLoadingChange(_ isLoading: Bool) {
        if isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
    
    func onRestaurantItemCell(_ items: [RestaurantItemCellController]) {
        restaurantCollection = items
        tableView.reloadData()
    }
    
}

