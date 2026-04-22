//
//  StackOverflowService.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import Foundation

protocol StackOverflowServiceProtocol {
    func topUsers() async throws -> Data
}

class StackOverflowService: StackOverflowServiceProtocol {
    enum Error: Swift.Error { case invalidURL }
    
    func topUsers() async throws -> Data {
        let url = URL(string: "https://api.stackexchange.com/2.2/users?page=1&pagesize=20&order=desc&sort=reputation&site=stackoverflow")
        
        guard let url else { throw Error.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
