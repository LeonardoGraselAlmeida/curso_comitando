//
//  RestaurantListViewController.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 13/03/23.
//

import UIKit

final class RestaurantListViewController: UITableViewController {
    
    var restaurantCollection = [RestaurantItemCellController]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var refreshController: RefreshController?
    
    convenience init(refreshController: RefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return restaurantCollection[indexPath.row].renderCell()
    }
} 

