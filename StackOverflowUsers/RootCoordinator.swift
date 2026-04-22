//
//  RootCoordinator.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

class RootCoordinator {
    private let navigationController: UINavigationController
    private var userCoordinator: UsersCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.navigationBar.prefersLargeTitles = true
        showUsers()
    }
}

extension RootCoordinator {
    func showUsers() {
        userCoordinator = UsersCoordinator(navigationController: navigationController)
        userCoordinator?.start()
    }
}
