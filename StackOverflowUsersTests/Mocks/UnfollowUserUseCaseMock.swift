//
//  UnfollowUserUseCaseMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

class UnfollowUserUseCaseMock: UnfollowUserUseCaseProtocol {
    private var _unfollow: (User) -> Void
    
    init(unfollow: @escaping (User) -> Void = { _ in XCTFail("Access to undefined method") }) {
        self._unfollow = unfollow
    }
    
    func unfollow(_ user: User) {
        _unfollow(user)
    }
}
