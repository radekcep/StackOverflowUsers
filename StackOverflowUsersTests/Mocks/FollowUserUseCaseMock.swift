//
//  FollowUserUseCaseMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

class FollowUserUseCaseMock: FollowUserUseCaseProtocol {
    private var _follow: (User) -> Void
    
    init(follow: @escaping (User) -> Void = { _ in XCTFail("Access to undefined method") }) {
        self._follow = follow
    }
    
    func follow(_ user: User) {
        _follow(user)
    }
}
