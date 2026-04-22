//
//  UsersListViewModel.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

// MARK: - Model

protocol UsersListViewControllerProtocol: AnyObject {
    func updateActivityIndicator()
    func updateRow(_ index: Int)
    func reloadData()
}

// MARK: - ViewModel

class UsersListViewModel {
    private let followUserUseCase: FollowUserUseCaseProtocol
    private let isUserFollowedUseCase: IsUserFollowedUseCaseProtocol
    private let topUsersUseCase: TopUsersUseCaseProtocol
    private let unfollowUserUseCase: UnfollowUserUseCaseProtocol
    
    private var topUsersLoadingTask: Task<(), any Error>?
    private var topUsers: [User] = []
    
    weak var view: UsersListViewControllerProtocol?
    
    var rows: [UserRowUIModel] = []
    var isLoading: Bool = true
    
    init(
        followUserUseCase: FollowUserUseCaseProtocol,
        isUserFollowedUseCase: IsUserFollowedUseCaseProtocol,
        topUsersUseCase: TopUsersUseCaseProtocol,
        unfollowUserUseCase: UnfollowUserUseCaseProtocol
    ) {
        self.followUserUseCase = followUserUseCase
        self.isUserFollowedUseCase = isUserFollowedUseCase
        self.topUsersUseCase = topUsersUseCase
        self.unfollowUserUseCase = unfollowUserUseCase
    }
    
    deinit {
        topUsersLoadingTask?.cancel()
    }
}

// MARK: - UsersListViewModelProtocol

extension UsersListViewModel: UsersListViewModelProtocol {
    func viewDidLoad() {
        reloadData()
    }
    
    func didFollowUser(at index: Int) {
        let user = topUsers[index]
        if isUserFollowedUseCase.isFollowed(user) {
            unfollowUserUseCase.unfollow(user)
        } else {
            followUserUseCase.follow(user)
        }
        
        rows[index] = .user(userUIModel(from: user))
        view?.updateRow(index)
    }
    
    func didSelectAction(at index: Int) {
        guard index == rows.endIndex else { return }
        // TODO: Show Error
    }
}

// MARK: - Data handling

private extension UsersListViewModel {
    func reloadData() {
        topUsersLoadingTask?.cancel()
        topUsers = []
        
        rows = []
        view?.reloadData()
        
        isLoading = true
        view?.updateActivityIndicator()
        
        topUsersLoadingTask = Task { [weak self, topUsersUseCase] in
            do {
                let topUsers = try await topUsersUseCase.topUsers()
                self?.load(topUsers)
            } catch is CancellationError {
                // Don't show errors on cancelation
            } catch {
                // TODO: Show Error
                self?.load([])
            }
        }
    }
    
    func load(_ topUsers: [User]) {
        self.topUsers = topUsers
        
        rows = topUsers.map { .user(userUIModel(from: $0)) }
        rows.append(.action(.init(title: "Show Error")))
        view?.reloadData()
        
        isLoading = false
        view?.updateActivityIndicator()
    }
    
    func userUIModel(from user: User) -> UserUIModel {
        .init(
            name: user.name,
            isFollowed: isUserFollowedUseCase.isFollowed(user)
        )
    }
}
