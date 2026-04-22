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
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func topUsers() async throws -> [User] {
        let data = try await networkService.download(Constant.topUsersURL)
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        return userResponse.items
    }
}

private enum Constant {
    static let topUsersURL = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow")!
}
