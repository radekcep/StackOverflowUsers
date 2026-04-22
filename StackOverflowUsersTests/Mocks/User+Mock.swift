//
//  User+Mock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

@testable import StackOverflowUsers

extension User {
    static func mock(
        id: Int = 42,
        name: String = "Mocked User",
        imageURL: String = "mocked/image/url",
        reputation: Int = 123456
    ) -> Self {
        .init(
            id: id,
            name: name,
            imageURL: imageURL,
            reputation: reputation
        )
    }
}
