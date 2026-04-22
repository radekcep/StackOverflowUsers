//
//  IsUserFollowedUseCaseMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

class IsUserFollowedUseCaseMock: IsUserFollowedUseCaseProtocol {
    private var _isFollowed: (User) -> Bool
    
    init(isFollowed: @escaping (User) -> Bool = { _ in XCTFail("Access to undefined method"); return false }) {
        self._isFollowed = isFollowed
    }
    
    func isFollowed(_ user: User) -> Bool {
        _isFollowed(user)
    }
}
