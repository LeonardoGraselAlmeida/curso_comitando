//
//  RestaurantListViewController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 13/03/23.
//

import UIKit

public final class RestaurantListViewController: UITableViewController {
    
    public var restaurantCollection: [RestaurantItemCellController] = []
    
    private let interactor: RestaurantListInteractorInput
    
    init(interactor: RestaurantListInteractorInput) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.register(RestaurantItemCell.self, forCellReuseIdentifier: RestaurantItemCell.identifier)
        refresh()
    }
    
    @objc func refresh() {
        interactor.loadService()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantCollection.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
