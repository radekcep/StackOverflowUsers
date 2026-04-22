//
//  TopUsersUseCaseTests.swift
//  StackOverflowUsersTests
//
//  Created by Radek on 22.04.2026.
//

import XCTest
@testable import StackOverflowUsers

@MainActor
final class TopUsersUseCaseTests: XCTestCase {
    func testParsingData() async throws {
        let responseData = try XCTUnwrap(String.responseJSON.data(using: .utf8))
        let stackOverflowService = StackOverflowServiceMock { responseData }
        
        let sut = TopUsersUseCase(stackOverflowService: stackOverflowService)
        let topUsers = try await sut.topUsers()
        
        XCTAssertEqual(topUsers.count, 1)
        let user = try XCTUnwrap(topUsers.first)
        XCTAssertEqual(user.id, 11683)
        XCTAssertEqual(user.name, "Jon Skeet")
        XCTAssertEqual(user.imageURL, "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG")
        XCTAssertEqual(user.reputation, 1454978)
    }
}

private extension String {
    static var responseJSON: Self {
        """
        {
          "items": [
            {
              "badge_counts": {
                "bronze": 9255,
                "silver": 9202,
                "gold": 877
              },
              "account_id": 11683,
              "is_employee": false,
              "last_modified_date": 1711287919,
              "last_access_date": 1711355649,
              "reputation_change_year": 13860,
              "reputation_change_quarter": 13860,
              "reputation_change_month": 3856,
              "reputation_change_week": 118,
              "reputation_change_day": 30,
              "reputation": 1454978,
              "creation_date": 1222430705,
              "user_type": "registered",
              "user_id": 22656,
              "accept_rate": 86,
              "location": "Reading, United Kingdom",
              "website_url": "http://csharpindepth.com",
              "link": "https://stackoverflow.com/users/22656/jon-skeet",
              "profile_image": "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG",
              "display_name": "Jon Skeet"
            }
          ]
        }
        """
    }
}

private class StackOverflowServiceMock: StackOverflowServiceProtocol {
    var topUsersMock: () async throws -> Data
    
    init(topUsersMock: @escaping () async throws -> Data) {
        self.topUsersMock = topUsersMock
    }
    
    func topUsers() async throws -> Data {
        try await topUsersMock()
    }
}
