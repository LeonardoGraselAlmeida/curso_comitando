//
//  ViewCodeProtocol.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 19/03/23.
//

import Foundation

public protocol ViewCode {
    func buildViewHierarchy()
    func setupConstraints()
    func setupAdditionalConfiguration()
    func setupView()
}

extension ViewCode {
    func setupView() {
        buildViewHierarchy()
        setupConstraints()
        setupAdditionalConfiguration()
    }
    
    func setupAdditionalConfiguration() {}
}
