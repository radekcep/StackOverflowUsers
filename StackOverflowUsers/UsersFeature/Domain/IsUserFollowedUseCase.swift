//
//  IsUserFollowedUseCase.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

protocol IsUserFollowedUseCaseProtocol {
    func isFollowed(_ user: User) -> Bool
}

class IsUserFollowedUseCase: IsUserFollowedUseCaseProtocol {
    private let keyValueStorage: KeyValueStorageProtocol
    
    init(keyValueStorage: KeyValueStorageProtocol) {
        self.keyValueStorage = keyValueStorage
    }
    
    func isFollowed(_ user: User) -> Bool {
        keyValueStorage.value(forKey: String(user.id)) ?? false
    }
}
