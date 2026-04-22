//
//  FollowUserUseCaseTests.swift
//  StackOverflowUsersTests
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

final class FollowUserUseCaseTests: XCTestCase {
    func testFollowUser() throws {
        var accessedKey: String?
        var accessedValue: Bool?
        let keyValueService = KeyValueStorageMock(
            setValue: { (accessedKey, accessedValue) = ($1, $0) },
            value: { _ in XCTFail("Set should not be accessed"); return false }
        )
    
        let sut = FollowUserUseCase(keyValueStorage: keyValueService)
        sut.follow(.mock(id: 42))
        
        XCTAssertEqual(accessedKey, "42")
        XCTAssertEqual(accessedValue, true)
    }
}
