//
//  UnfollowUserUseCase.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

protocol UnfollowUserUseCaseProtocol {
    func unfollow(_ user: User)
}

class UnfollowUserUseCase: UnfollowUserUseCaseProtocol {
    private let keyValueStorage: KeyValueStorageProtocol
    
    init(keyValueStorage: KeyValueStorageProtocol) {
        self.keyValueStorage = keyValueStorage
    }
    
    func unfollow(_ user: User) {
        keyValueStorage.set(value: false, forKey: String(user.id))
    }
}
