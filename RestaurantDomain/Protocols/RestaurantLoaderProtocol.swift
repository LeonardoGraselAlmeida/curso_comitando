//
//  RestaurantLoaderProtocol.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 26/02/23.
//

import Foundation

public enum RestaurantResultError: Error {
    case connectivity
    case invalidData
}

public protocol RestaurantLoaderProtocol {
    typealias RestaurantResult = Result<[RestaurantItem], RestaurantResultError>
    func load(completion: @escaping (RestaurantResult) -> Void)
}


 
