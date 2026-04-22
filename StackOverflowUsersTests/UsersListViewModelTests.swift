//
//  UsersListViewModelTests.swift
//  StackOverflowUsersTests
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

@MainActor
final class UsersListViewModelTests: XCTestCase {
    func testIsPassiveOnInit() {
        let sut = UsersListViewModel(
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock(),
            topUsersUseCase: TopUsersUseCaseMock(),
            unfollowUserUseCase: UnfollowUserUseCaseMock()
        )
        
        let view = UsersListViewControllerMock()
        sut.view = view
        
        XCTAssert(sut.isLoading)
    }
    
    func testLoadedData() async {
        let loadedData = [
            User.mock(id: 1, name: "First User"),
            User.mock(id: 2, name: "Second User"),
            User.mock(id: 3, name: "Third User")
        ]
        
        let sut = UsersListViewModel(
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock { $0.id == 2 },
            topUsersUseCase: TopUsersUseCaseMock { loadedData },
            unfollowUserUseCase: UnfollowUserUseCaseMock()
        )
        
        var updateActivityIndicatorCalled = false
        var reloadDataCalled = false
        let view = UsersListViewControllerMock(
            updateActivityIndicator: { updateActivityIndicatorCalled = true },
            reloadData: { reloadDataCalled = true }
        )
        sut.view = view
        
        sut.viewDidLoad()
        await Task.yield()
        
        XCTAssert(updateActivityIndicatorCalled)
        XCTAssert(reloadDataCalled)
        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.rows, [
            .user(.init(name: "First User", isFollowed: false)),
            .user(.init(name: "Second User", isFollowed: true)),
            .user(.init(name: "Third User", isFollowed: false)),
            .action(.init(title: "Show Error")),
        ])
    }
    
    func testTaskCancelledOnDeinit() async {
        let expectation = expectation(description: #function)
        var sut: UsersListViewModel? = UsersListViewModel(
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock(),
            topUsersUseCase: TopUsersUseCaseMock {
                try await withTaskCancellationHandler {
                    try await Task.sleep(for: .seconds(1))
                    XCTFail("Task was not cancelled")
                    return []
                } onCancel: {
                    expectation.fulfill()
                }
            },
            unfollowUserUseCase: UnfollowUserUseCaseMock()
        )

        sut?.viewDidLoad()
        sut = nil

        await fulfillment(of: [expectation], timeout: 2)
    }
    
    func testFollowingUser() async {
        let loadedData = [
            User.mock(id: 1, name: "First User"),
            User.mock(id: 2, name: "Second User"),
            User.mock(id: 3, name: "Third User")
        ]
        
        var followedUser: User?
        let sut = UsersListViewModel(
            followUserUseCase: FollowUserUseCaseMock { followedUser = $0 },
            isUserFollowedUseCase: IsUserFollowedUseCaseMock { $0.id == 2 },
            topUsersUseCase: TopUsersUseCaseMock { loadedData },
            unfollowUserUseCase: UnfollowUserUseCaseMock()
        )
        
        var rowUpdated: Int?
        let view = UsersListViewControllerMock(
            updateActivityIndicator: {},
            updateRow: { rowUpdated = $0 },
            reloadData: {}
        )
        sut.view = view
        
        sut.viewDidLoad()
        await Task.yield()
        sut.didFollowUser(at: 0)
        
        XCTAssertEqual(followedUser?.id, 1)
        XCTAssertEqual(rowUpdated, 0)
    }
    
    func testUnfollowingUser() async {
        let loadedData = [
            User.mock(id: 1, name: "First User"),
            User.mock(id: 2, name: "Second User"),
            User.mock(id: 3, name: "Third User")
        ]
        
        var unfollowedUser: User?
        let sut = UsersListViewModel(
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock { $0.id == 2 },
            topUsersUseCase: TopUsersUseCaseMock { loadedData },
            unfollowUserUseCase: UnfollowUserUseCaseMock { unfollowedUser = $0 }
        )
        
        var rowUpdated: Int?
        let view = UsersListViewControllerMock(
            updateActivityIndicator: {},
            updateRow: { rowUpdated = $0 },
            reloadData: {}
        )
        sut.view = view
        
        sut.viewDidLoad()
        await Task.yield()
        sut.didFollowUser(at: 1)
        
        XCTAssertEqual(unfollowedUser?.id, 2)
        XCTAssertEqual(rowUpdated, 1)
    }
}
