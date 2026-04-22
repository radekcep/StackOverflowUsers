//
//  TopUsersUseCaseMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

class TopUsersUseCaseMock: TopUsersUseCaseProtocol {
    private var _topUsers: () async throws -> [User]
    
    init(topUsers: @escaping () async throws -> [User] = { XCTFail("Access to undefined method"); return [] }) {
        self._topUsers = topUsers
    }
    
    func topUsers() async throws -> [User] {
        try await _topUsers()
    }
}
