//
//  UsersListViewControllerMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

class UsersListViewControllerMock: UsersListViewControllerProtocol {
    var _updateActivityIndicator: () -> Void
    var _updateRow: (Int) -> Void
    var _reloadData: () -> Void
    
    init(
        updateActivityIndicator: @escaping () -> Void = { XCTFail("Access to undefined method") },
        updateRow: @escaping (Int) -> Void = { _ in XCTFail("Access to undefined method") },
        reloadData: @escaping () -> Void = { XCTFail("Access to undefined method") }
    ) {
        self._updateActivityIndicator = updateActivityIndicator
        self._updateRow = updateRow
        self._reloadData = reloadData
    }
    
    func updateActivityIndicator() {
        _updateActivityIndicator()
    }
    
    func updateRow(at index: Int) {
        _updateRow(index)
    }
    
    func reloadData() {
        _reloadData()
    }
}
