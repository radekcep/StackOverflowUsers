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
    func testFetchingData() async throws {
        var requestedURL: URL?
        let responseData = try XCTUnwrap(String.responseJSON.data(using: .utf8))
        let networkService = NetworkServiceMock { requestedURL = $0; return responseData }
        
        let sut = TopUsersUseCase(networkService: networkService)
        let topUsers = try await sut.topUsers()
        
        XCTAssertEqual(requestedURL, URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow")!)
        XCTAssertEqual(topUsers.count, 1)
        let user = try XCTUnwrap(topUsers.first)
        XCTAssertEqual(user.id, 11683)
        XCTAssertEqual(user.name, "Jon Skeet")
        XCTAssertEqual(user.imageURL, URL(string: "https://www.gravatar.com/avatar/6d8ebb117e8d83d74ea95fbdd0f87e13?s=256&d=identicon&r=PG")!)
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
