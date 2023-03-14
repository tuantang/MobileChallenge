//
//  ApplicationFlowCoordinatorDependencyProvider.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 13/03/2023.
//

import UIKit

protocol ApplicationFlowCoordinatorDependencyProvider: MoviesFlowCoordinatorDependencyProvider {}

protocol MoviesFlowCoordinatorDependencyProvider {
    func moviesNavigationController() -> UINavigationController
}
