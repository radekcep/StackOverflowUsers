//
//  UsersListViewModel.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

// MARK: - Model

protocol UsersListViewControllerProtocol: AnyObject {
    func updateActivityIndicator()
    func updateRow(at index: Int)
    func reloadData()
}

// MARK: - ViewModel

class UsersListViewModel {
    private let downloadImageUseCase: DownloadImageUseCaseProtocol
    private let followUserUseCase: FollowUserUseCaseProtocol
    private let isUserFollowedUseCase: IsUserFollowedUseCaseProtocol
    private let loadLocalImageUseCase: LoadLocalImageUseCaseProtocol
    private let topUsersUseCase: TopUsersUseCaseProtocol
    private let unfollowUserUseCase: UnfollowUserUseCaseProtocol
    
    private var usersLoadingTask: Task<(), any Error>?
    private var users: [User] = []
    
    weak var view: UsersListViewControllerProtocol?
    
    var isLoading: Bool = true {
        didSet { view?.updateActivityIndicator() }
    }
    
    init(
        downloadImageUseCase: DownloadImageUseCaseProtocol,
        followUserUseCase: FollowUserUseCaseProtocol,
        isUserFollowedUseCase: IsUserFollowedUseCaseProtocol,
        loadLocalImageUseCase: LoadLocalImageUseCaseProtocol,
        topUsersUseCase: TopUsersUseCaseProtocol,
        unfollowUserUseCase: UnfollowUserUseCaseProtocol
    ) {
        self.downloadImageUseCase = downloadImageUseCase
        self.followUserUseCase = followUserUseCase
        self.isUserFollowedUseCase = isUserFollowedUseCase
        self.loadLocalImageUseCase = loadLocalImageUseCase
        self.topUsersUseCase = topUsersUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
    }
    
    deinit {
        usersLoadingTask?.cancel()
    }
}

// MARK: - UsersListViewModelProtocol

extension UsersListViewModel: UsersListViewModelProtocol {
    var numberOfItems: Int {
        if users.count == .zero { .zero }
        else { users.count + 1 }
    }
    
    func viewDidLoad() {
        reloadData()
    }
    
    func didFollowUser(at index: Int) {
        let user = users[index]
        if isUserFollowedUseCase.isFollowed(user) {
            unfollowUserUseCase.unfollow(user)
        } else {
            followUserUseCase.follow(user)
        }
        
        view?.updateRow(at: index)
    }
    
    func didSelectAction(at index: Int) {
        // TODO: Show Error
    }
    
    func usersListRowUIModel(at index: Int) -> UsersListRowUIModel {
        if users.indices.contains(index) {
            usersListRowUIModel(from: users[index])
        } else {
            .action(.init(title: "Show Error"))
        }
    }
}

// MARK: - Data Handling

private extension UsersListViewModel {
    func reloadData() {
        usersLoadingTask?.cancel()
        
        users = []
        view?.reloadData()
        
        isLoading = true
        usersLoadingTask = Task { [weak self, topUsersUseCase] in
            do {
                let users = try await topUsersUseCase.topUsers()
                self?.users = users
                self?.view?.reloadData()
            } catch is CancellationError {
                // Don't show errors on cancelation
            } catch {
                // TODO: Show Error
            }
            
            self?.isLoading = false
            await self?.downloadMissingUserImages()
        }
    }
        
    func downloadMissingUserImages() async {
        await withTaskGroup(of: Int?.self) { [weak self, users, downloadImageUseCase, loadLocalImageUseCase] group in
            for (index, user) in users.enumerated() where loadLocalImageUseCase.image(for: user.imageURL) == nil {
                group.addTask {
                    let image = try? await downloadImageUseCase.download(user.imageURL)
                    return image.map { _ in index }
                }
            }
            
            for await case let index? in group {
                self?.view?.updateRow(at: index)
            }
        }
    }
    
    func usersListRowUIModel(from user: User) -> UsersListRowUIModel {
        let isFollowed = isUserFollowedUseCase.isFollowed(user)
        let image = loadLocalImageUseCase.image(for: user.imageURL)
        
        return .user(.init(
            name: user.name,
            image: image ?? Constant.fallbackUserImage,
            reputation: String(user.reputation),
            isFollowed: isFollowed
        ))
    }
}

// MARK: - Constant

private enum Constant {
    static let fallbackUserImage = UIImage(systemName: "person.circle")!
}
