//
//  UnfollowUserUseCaseTests.swift
//  StackOverflowUsersTests
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

final class UnfollowUserUseCaseTests: XCTestCase {
    func testUnfollowUser() throws {
        var accessedKey: String?
        var accessedValue: Bool?
        let keyValueService = KeyValueStorageMock(
            setValue: { (accessedKey, accessedValue) = ($1, $0) },
            value: { _ in XCTFail("Set should not be accessed"); return false }
        )
    
        let sut = UnfollowUserUseCase(keyValueStorage: keyValueService)
        sut.unfollow(.mock(id: 42))
        
        XCTAssertEqual(accessedKey, "42")
        XCTAssertEqual(accessedValue, false)
    }
}
