//
//  SceneDelegateMock.swift
//  SunnyDay
//
//  Created by Leonardo Almeida on 08/10/2023.
//

#if DEBUG
import UIKit
import RestaurantDomain

class SceneDelegateMock: SceneDelegate {
    
    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if CommandLine.arguments.contains("-reset") {
            try? FileManager.default.removeItem(at: fileManagerURL)
        }
        
        super.scene(scene, willConnectTo: session, options: connectionOptions)
    }
    
    override func makeRemoteLoader() -> RestaurantLoaderProtocol {
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            return RestaurantLoaderMock()
        }
        
        return super.makeRemoteLoader()
    }
}

private final class RestaurantLoaderMock: RestaurantLoaderProtocol {
    func load(completion: @escaping (Result<[RestaurantItem], RestaurantResultError>) -> Void) {
        completion(.failure(.connectivity))
    }
}
#endif
