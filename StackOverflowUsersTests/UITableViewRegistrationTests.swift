//
//  UITableViewRegistrationTests.swift
//  StackOverflowUsersTests
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

final class UITableViewRegistrationTests: XCTestCase {
    func testCellsRegistration() {
        let sut = UITableView()
        
        sut.register(DummyCell0.self)
        sut.register(DummyCell1.self)
        
        XCTAssertNotNil(sut.dequeueReusableCell(for: .init(index: 0)) as DummyCell0)
        XCTAssertNotNil(sut.dequeueReusableCell(for: .init(index: 1)) as DummyCell1)
    }
}

private class DummyCell0: UITableViewCell {}
private class DummyCell1: UITableViewCell {}
