//
//  RestaurantItemCell.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 18/03/23.
//

import UIKit
import RestaurantDomain

class RestaurantItemCell: UITableViewCell {
    lazy var title: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var location: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var distance: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var parasols: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var collectionOfRating: [UIImageView] = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return [
            imageView,
            imageView,
            imageView,
            imageView,
            imageView
        ]
    }()
}
