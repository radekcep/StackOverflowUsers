//
//  DownloadImageUseCaseMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit
import XCTest
@testable import StackOverflowUsers

class DownloadImageUseCaseMock: DownloadImageUseCaseProtocol {
    let _download: (URL) async throws -> UIImage
    
    init(_download: @escaping (URL) async throws -> UIImage = { _ in XCTFail("Access to undefined method"); return UIImage() }) {
        self._download = _download
    }
    
    func download(_ url: URL) async throws -> UIImage {
        try await _download(url)
    }
}
