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
        let keyValueStorage = KeyValueStorage(userDefaults: .standard)
        let networkService = NetworkService()
        let imageCache = NSCache<NSURL, UIImage>()
        
        let viewModel = UsersListViewModel(
            downloadImageUseCase: DownloadImageUseCase(networkService: networkService, imageCache: imageCache),
            followUserUseCase: FollowUserUseCase(keyValueStorage: keyValueStorage),
            isUserFollowedUseCase: IsUserFollowedUseCase(keyValueStorage: keyValueStorage),
            loadLocalImageUseCase: LoadLocalImageUseCase(imageCache: imageCache),
            topUsersUseCase: TopUsersUseCase(networkService: networkService),
            unfollowUserUseCase: UnfollowUserUseCase(keyValueStorage: keyValueStorage)
        )
        let viewController = UsersListViewController(viewModel: viewModel)
        viewModel.view = viewController
        
        navigationController.viewControllers = [viewController]
    }
}
