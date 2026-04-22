//
//  LoadLocalImageUseCase.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import UIKit

protocol LoadLocalImageUseCaseProtocol {
    func image(for url: URL) -> UIImage?
}

class LoadLocalImageUseCase: LoadLocalImageUseCaseProtocol {
    let imageCache: NSCache<NSURL, UIImage>
    
    init(imageCache: NSCache<NSURL, UIImage>) {
        self.imageCache = imageCache
    }
    
    func image(for url: URL) -> UIImage? {
        imageCache.object(forKey: url as NSURL)
    }
}
