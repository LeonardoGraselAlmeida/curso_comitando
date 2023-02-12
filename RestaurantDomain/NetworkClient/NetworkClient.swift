//
//  NetworkClient.swift
//  RestaurantDomain
//
//  Created by Leonardo Almeida on 08/02/23.
//

import Foundation

public protocol NetworkClient {
    typealias NetworkResult = Result<(Data, HTTPURLResponse), Error>
    func request(from url: URL, completion: @escaping (NetworkResult) -> Void)
}
