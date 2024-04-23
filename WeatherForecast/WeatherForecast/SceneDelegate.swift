//
//  WeatherForecast - SceneDelegate.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene: UIWindowScene = (scene as? UIWindowScene) else { return }
        
        let container = DIContainer.shared
        
        container.register(
            type: WeatherServiceable.self,
            component: WeatherAPI()
        )
        
        let weatherAPI = container.resolve(type: WeatherServiceable.self)
        
        container.register(
            type: WeatherViewController.self,
            component: WeatherViewController(
                api: weatherAPI)
        )
        
        let viewController = container.resolve(type: WeatherViewController.self)

        let navigationController: UINavigationController = UINavigationController(rootViewController: viewController)

        let window: UIWindow = UIWindow(windowScene: scene)
        window.rootViewController = navigationController
        
        self.window = window
        self.window?.backgroundColor = .white
        window.makeKeyAndVisible()
        
    }
}

