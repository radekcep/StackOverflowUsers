//
//  TopUsersUseCase.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import Foundation

protocol TopUsersUseCaseProtocol {
    func topUsers() async throws -> [User]
}

class TopUsersUseCase: TopUsersUseCaseProtocol {
    private let stackOverflowService: StackOverflowServiceProtocol
    
    init(stackOverflowService: StackOverflowServiceProtocol) {
        self.stackOverflowService = stackOverflowService
    }
    
    func topUsers() async throws -> [User] {
        let data = try await stackOverflowService.topUsers()
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return userResponse.items
    }
}
