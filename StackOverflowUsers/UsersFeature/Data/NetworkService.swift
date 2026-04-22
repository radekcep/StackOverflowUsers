//
//  NetworkService.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import Foundation

protocol NetworkServiceProtocol {
    func download(_ url: URL) async throws -> Data
}

class NetworkService: NetworkServiceProtocol {
    func download(_ url: URL) async throws -> Data {
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}
