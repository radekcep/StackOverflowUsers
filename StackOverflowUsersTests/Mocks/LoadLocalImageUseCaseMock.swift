//
//  LoadLocalImageUseCaseMock.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit
import XCTest
@testable import StackOverflowUsers

class LoadLocalImageUseCaseMock: LoadLocalImageUseCaseProtocol {
    private let _image: (URL) -> UIImage?
    
    init(_image: @escaping (URL) -> UIImage? = { _ in XCTFail("Access to undefined method"); return nil }) {
        self._image = _image
    }
    
    func image(for url: URL) -> UIImage? {
        _image(url)
    }
}
