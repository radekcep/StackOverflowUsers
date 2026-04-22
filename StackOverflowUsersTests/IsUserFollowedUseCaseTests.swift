//
//  IsUserFollowedUseCaseTests.swift
//  StackOverflowUsersTests
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

final class IsUserFollowedUseCaseTests: XCTestCase {
    func testNoValue() {
        var accessedKey: String?
        let keyValueService = KeyValueStorageMock(
            setValue: { _, _ in XCTFail("Set should not be accessed") },
            value: { accessedKey = $0; return nil }
        )
    
        let sut = IsUserFollowedUseCase(keyValueStorage: keyValueService)
        
        XCTAssertFalse(sut.isFollowed(.mock(id: 1)))
        XCTAssertEqual(accessedKey, "1")
    }
    
    func testIsFollowed() {
        var accessedKey: String?
        let keyValueService = KeyValueStorageMock(
            setValue: { _, _ in XCTFail("Set should not be accessed") },
            value: { accessedKey = $0; return true }
        )
    
        let sut = IsUserFollowedUseCase(keyValueStorage: keyValueService)
        
        XCTAssert(sut.isFollowed(.mock(id: 10)))
        XCTAssertEqual(accessedKey, "10")
    }
    
    func testIsNotFollowed() {
        var accessedKey: String?
        let keyValueService = KeyValueStorageMock(
            setValue: { _, _ in XCTFail("Set should not be accessed") },
            value: { accessedKey = $0; return false }
        )
    
        let sut = IsUserFollowedUseCase(keyValueStorage: keyValueService)
        
        XCTAssertFalse(sut.isFollowed(.mock(id: 100)))
        XCTAssertEqual(accessedKey, "100")
    }
}
