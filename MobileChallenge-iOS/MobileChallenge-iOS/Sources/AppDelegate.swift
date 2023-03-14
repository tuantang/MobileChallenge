//
//  AppDelegate.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: ApplicationFlowCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = ApplicationFlowCoordinator(window: window, dependencyProvider: ApplicationComponentsFactory())
        appCoordinator.start()
        
        self.window = window
        self.window?.makeKeyAndVisible()
        return true
    }
}


