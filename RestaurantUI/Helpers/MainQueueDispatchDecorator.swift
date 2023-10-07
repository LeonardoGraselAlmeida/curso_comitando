//
//  MainQueueDispatchDecorator.swift
//  RestaurantUI
//
//  Created by Leonardo Almeida on 25/09/2023.
//

import Foundation

public final class MainQueueDispatchDecorator<T> {
    
    internal let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        completion()
    }
}

extension DispatchQueue {
    func safeAsync(_ block: @escaping () -> Void) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            async {
                block()
            }
        }
    }
}
