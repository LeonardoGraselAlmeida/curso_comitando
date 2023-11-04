//
//  SceneDelegate.swift
//  SunnyDay
//
//  Created by Leonardo Almeida on 07/10/2023.
//

import UIKit
import RestaurantUI
import RestaurantDomain
import NetworkClient

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var localService = {
        let cache = CacheService(managerURL: fileManagerURL)
        return LocalRestaurantLoader(cache: cache, currentDate: Date.init)
    }()
    
    lazy var fileManagerURL = {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathExtension("SunnyDay.store")
    }()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let compositeService = RestaurantLoaderCompositeRemoteAndLocal(main: makeRemoteLoader(), fallback: localService)
        let decoratorService = RestaurantLoaderCacheDecorator(decoratee: compositeService, cache: localService)
        
        let controller = RestaurantListCompose.compose(service: decoratorService)
        let navigation = UINavigationController(rootViewController: controller)
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
    
    private func remoteService() -> RestaurantLoaderProtocol {
        let session = URLSession(configuration: .ephemeral)
        let network = NetworkService(session: session)
        let url = URL(string: "https://raw.githubusercontent.com/comitando/assets/main/api/restaurant_list_endpoint.json")!
        return RemoteRestaurantLoader(url: url, networkClient: network)
    }
    
    func makeRemoteLoader() -> RestaurantLoaderProtocol {
        return remoteService()
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        localService.validateCache()
    }
    
}
