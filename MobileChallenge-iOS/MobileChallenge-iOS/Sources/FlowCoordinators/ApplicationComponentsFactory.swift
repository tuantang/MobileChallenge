//
//  ApplicationComponentsFactory.swift
//  MobileChallenge-iOS
//
//  Created by Tuấn Tăng on 14/03/2023.
//

import UIKit

class ApplicationComponentsFactory: ApplicationFlowCoordinatorDependencyProvider {
    
    func moviesNavigationController() -> UINavigationController {
        let viewController = MoviesViewController(viewModel: MoviesViewModel())
        return UINavigationController(rootViewController: viewController)
    }
}
