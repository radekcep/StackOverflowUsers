//
//  NetworkServiceMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import Foundation
import XCTest
@testable import StackOverflowUsers

class NetworkServiceMock: NetworkServiceProtocol {
    private var _download: (URL) async throws -> Data
    
    init(download: @escaping (URL) async throws -> Data = { _ in XCTFail("Access to undefined method"); return Data() }) {
        self._download = download
    }
    
    func download(_ url: URL) async throws -> Data {
        try await _download(url)
    }
}
