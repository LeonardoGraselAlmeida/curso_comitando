//
//  CacheClientSpy.swift
//  RestaurantDomainTests
//
//  Created by Leonardo Almeida on 26/02/23.
//

import Foundation
import RestaurantDomain

final class CacheClientSpy: CacheClient {
    
    enum Methods: Equatable {
        case delete
        case save(items: [RestaurantItem], timestamp: Date)
        case load
    }
    
    private(set) var methodsCalled = [Methods]()
    
    
    private var completionHandlerInsert: ((Error?) -> Void)?
    func save(_ items: [RestaurantDomain.RestaurantItem], timestamp: Date, completion: @escaping CacheClient.SaveResult) {
        methodsCalled.append(.save(items: items, timestamp: timestamp))
        completionHandlerInsert = completion
    }
   
    private var completionHandlerDelete: ((Error?) -> Void)?
    func delete(completion: @escaping CacheClient.DeleteResult) {
        methodsCalled.append(.delete)
        completionHandlerDelete = completion
    }
    
    private var completionHandlerLoad: (LoadResult)?
    func load(completion: @escaping LoadResult) {
        methodsCalled.append(.load)
        completionHandlerLoad = completion
    }
    
    func completionHandlerForDelete(_ error: Error?) {
        completionHandlerDelete?(error)
    }
    
    func completionHandlerForInsert(_ error: Error?) {
        completionHandlerInsert?(error)
    }
    
    func completionHandlerForLoad(_ state: LoadResultState) {
        completionHandlerLoad?(state)
    }
}
