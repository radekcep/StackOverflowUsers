//
//  FetchImageUseCase.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

protocol DownloadImageUseCaseProtocol {
    func download(_ url: URL) async throws -> UIImage
}

class DownloadImageUseCase: DownloadImageUseCaseProtocol {
    enum Error: Swift.Error { case invalidData }
    
    let networkService: NetworkServiceProtocol
    let imageCache: NSCache<NSURL, UIImage>
    
    init(networkService: NetworkServiceProtocol, imageCache: NSCache<NSURL, UIImage>) {
        self.networkService = networkService
        self.imageCache = imageCache
    }
    
    func download(_ url: URL) async throws -> UIImage {
        let data = try await networkService.download(url)
        guard let image = UIImage(data: data) else { throw Error.invalidData }
        imageCache.setObject(image, forKey: url as NSURL)
        return image
    }
}
