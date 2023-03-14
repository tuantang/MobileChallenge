//
//  ApplicationFlowCoordinator.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import UIKit

class ApplicationFlowCoordinator: FlowCoordinator {
    
    typealias DependencyProvider = ApplicationFlowCoordinatorDependencyProvider
    
    private let window: UIWindow
    private let dependencyProvider: DependencyProvider
    private var childCoordinators: [FlowCoordinator] = []
    
    init(window: UIWindow, dependencyProvider: DependencyProvider) {
        self.window = window
        self.dependencyProvider = dependencyProvider
    }
    
    func start() {
        let moviesFlowCoordinator = MoviesFlowCoordinator(window: window, dependencyProvider: dependencyProvider)
        childCoordinators = [moviesFlowCoordinator]
        moviesFlowCoordinator.start()
    }
}
