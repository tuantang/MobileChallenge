//
//  MoviesFlowCoordinator.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import UIKit

class MoviesFlowCoordinator: FlowCoordinator {
    
    fileprivate let window: UIWindow
    fileprivate var moviesNavigationController: UINavigationController?
    fileprivate let dependencyProvider: MoviesFlowCoordinatorDependencyProvider
    
    init(window: UIWindow, dependencyProvider: MoviesFlowCoordinatorDependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let moviesNavigationController = dependencyProvider.moviesNavigationController()
        window.rootViewController = moviesNavigationController
        self.moviesNavigationController = moviesNavigationController
    }
}
