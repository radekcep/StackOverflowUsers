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
            downloadImageUseCase: DownloadImageUseCaseMock(),
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock(),
            loadLocalImageUseCase: LoadLocalImageUseCaseMock(),
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
            downloadImageUseCase: DownloadImageUseCaseMock { _ in throw ErrorStub() },
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock { $0.id == 2 },
            loadLocalImageUseCase: LoadLocalImageUseCaseMock { _ in nil },
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
        XCTAssertEqual(sut.numberOfItems, 4)
        XCTAssertEqual(sut.usersListRowUIModel(at: 0), .user(.init(name: "First User", image: UIImage(systemName: "person.circle")!, isFollowed: false)))
        XCTAssertEqual(sut.usersListRowUIModel(at: 1), .user(.init(name: "Second User", image: UIImage(systemName: "person.circle")!, isFollowed: true)))
        XCTAssertEqual(sut.usersListRowUIModel(at: 2), .user(.init(name: "Third User", image: UIImage(systemName: "person.circle")!, isFollowed: false)))
        XCTAssertEqual(sut.usersListRowUIModel(at: 3), .action(.init(title: "Show Error")))
    }
    
    func testTaskCancelledOnDeinit() async {
        let expectation = expectation(description: #function)
        var sut: UsersListViewModel? = UsersListViewModel(
            downloadImageUseCase: DownloadImageUseCaseMock { _ in throw ErrorStub() },
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock(),
            loadLocalImageUseCase: LoadLocalImageUseCaseMock { _ in nil },
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
            downloadImageUseCase: DownloadImageUseCaseMock { _ in throw ErrorStub() },
            followUserUseCase: FollowUserUseCaseMock { followedUser = $0 },
            isUserFollowedUseCase: IsUserFollowedUseCaseMock { $0.id == 2 },
            loadLocalImageUseCase: LoadLocalImageUseCaseMock { _ in nil },
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
            downloadImageUseCase: DownloadImageUseCaseMock { _ in throw ErrorStub() },
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock { $0.id == 2 },
            loadLocalImageUseCase: LoadLocalImageUseCaseMock { _ in nil },
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
    
    func testImagesDownload() async {
        let updateRowExpectation = self.expectation(description: "Rows should be updated with downloaded images")
        updateRowExpectation.expectedFulfillmentCount = 2
        
        let loadedData = [
            User.mock(id: 1, name: "First User", imageURL: URL(string: "mocked/image/url/1")!),
            User.mock(id: 2, name: "Second User", imageURL: URL(string: "mocked/image/url/2")!),
            User.mock(id: 3, name: "Third User", imageURL: URL(string: "mocked/image/url/3")!),
        ]
        
        var downloadsRequested = [URL]()
        let sut = UsersListViewModel(
            downloadImageUseCase: DownloadImageUseCaseMock { url in
                downloadsRequested.append(url);
                return UIImage(systemName: "person.circle")!
            },
            followUserUseCase: FollowUserUseCaseMock(),
            isUserFollowedUseCase: IsUserFollowedUseCaseMock(),
            loadLocalImageUseCase: LoadLocalImageUseCaseMock { url in
                switch url {
                case URL(string: "mocked/image/url/1")!: nil
                case URL(string: "mocked/image/url/2")!: UIImage(systemName: "person.circle")!
                case URL(string: "mocked/image/url/3")!: nil
                default: fatalError("Invalid path")
                }
            },
            topUsersUseCase: TopUsersUseCaseMock { loadedData },
            unfollowUserUseCase: UnfollowUserUseCaseMock()
        )
        var updatedRows = [Int]()
        let view = UsersListViewControllerMock(
            updateActivityIndicator: {},
            updateRow: { updatedRows.append($0); updateRowExpectation.fulfill() },
            reloadData: {}
        )
        sut.view = view
        
        sut.viewDidLoad()
        await fulfillment(of: [updateRowExpectation])
        
        XCTAssertEqual(downloadsRequested, [
            URL(string: "mocked/image/url/1")!,
            URL(string: "mocked/image/url/3")!,
        ])
        XCTAssertEqual(updatedRows.sorted(), [0, 2])
    }
}

private struct ErrorStub: Error {}
