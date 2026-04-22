//
//  UsersCoordinator.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

class UsersCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = UsersListViewModel(
            followUserUseCase: FollowUserUseCase(keyValueStorage: KeyValueStorage(userDefaults: .standard)),
            isUserFollowedUseCase: IsUserFollowedUseCase(keyValueStorage: KeyValueStorage(userDefaults: .standard)),
            topUsersUseCase: TopUsersUseCase(stackOverflowService: StackOverflowService()),
            unfollowUserUseCase: UnfollowUserUseCase(keyValueStorage: KeyValueStorage(userDefaults: .standard))
        )
        let viewController = UsersListViewController(viewModel: viewModel)
        viewModel.view = viewController
        
        navigationController.viewControllers = [viewController]
    }
}
