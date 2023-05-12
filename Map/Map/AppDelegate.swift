//
//  AppDelegate.swift
//  Map
//
//  Created by Alena Sidorova on 12.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)

        let presenter = MapPresenter(networkService: NetworkService())
        let controller = ContainerViewController(contentViewController: MapViewController(presenter: presenter),
                                                 bottomSheetViewController: InfoBottomSheet(presenter: presenter))
        window.rootViewController = UINavigationController(rootViewController: controller)
        window.makeKeyAndVisible()
        self.window = window

        return true
    }
}

