//
//  RestaurantItemCell.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 18/03/23.
//

import UIKit

extension RestaurantItemCell {
    static var identifier: String {
        return "\(type(of: self))"
    }
}

class RestaurantItemCell: UITableViewCell {
    
    private(set) lazy var hstack: UIStackView = renderStack(axis: .horizontal, spacing: 16, alignment: .center)
    private(set) lazy var vstack: UIStackView = renderStack(axis: .vertical, spacing: 4, alignment: .leading)
    private(set) lazy var hRatingStack: UIStackView = renderStack(axis: .horizontal, spacing: 0, alignment: .fill)
    
    private(set) lazy var mapImage = renderImage("map")
    
    private(set) lazy var title: UILabel = renderLabel(font: .preferredFont(forTextStyle: .title2))
    private(set) lazy var location: UILabel = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var distance: UILabel = renderLabel(font: .preferredFont(forTextStyle: .body))
    private(set) lazy var parasols: UILabel = renderLabel(font: .preferredFont(forTextStyle: .body))
    
    private(set) lazy var collectionOfRating: [UIImageView] = renderCollectionOfImage()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    private func renderLabel(font: UIFont, textColor: UIColor = .black) -> UILabel {
        let label = UILabel()
        label.font = font
        label.tintColor = textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func renderStack(axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment) -> UIStackView {
        let stack = UIStackView()
        stack.axis = axis
        stack.spacing = spacing
        stack.alignment = alignment
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }
    
    private func renderImage(_ systemName: String) -> UIImageView {
        let imageView = UIImageView()
        imageView.tintColor = .black
        imageView.image = UIImage(systemName: systemName)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func renderCollectionOfImage() -> [UIImageView] {
       var collection = [UIImageView]()
        for _ in 1...5 {
            collection.append(renderImage("star"))
        }
        return collection
    }
}

extension RestaurantItemCell: ViewCode {
    
    private var margin: CGFloat {
        return 16
    }
    
    func buildViewHierarchy() {
        contentView.addSubview(hstack)
        
        hstack.addArrangedSubview(mapImage)
        hstack.addArrangedSubview(vstack)
        
        vstack.addArrangedSubview(title)
        vstack.addArrangedSubview(location)
        vstack.addArrangedSubview(distance)
        vstack.addArrangedSubview(parasols)
        vstack.addArrangedSubview(hRatingStack)
        
        collectionOfRating.forEach { hRatingStack.addArrangedSubview($0) }
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            hstack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            hstack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            hstack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            hstack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),

        ])
    }
    
    public func setupAdditionalConfiguration() {
        accessoryType = .disclosureIndicator
    }
}
