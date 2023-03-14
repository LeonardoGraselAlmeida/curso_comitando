//
//  UIRefreshControl+Extension.swift
//  RestaurantUITests
//
//  Created by Leonardo Almeida on 13/03/23.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach({
                (target as NSObject).perform(Selector($0))
            })
        }
    }
}
