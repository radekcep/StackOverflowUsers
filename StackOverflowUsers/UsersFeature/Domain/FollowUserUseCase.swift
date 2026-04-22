//
//  FollowUserUseCase.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

protocol FollowUserUseCaseProtocol {
    func follow(_ user: User)
}

class FollowUserUseCase: FollowUserUseCaseProtocol {
    private let keyValueStorage: KeyValueStorageProtocol
    
    init(keyValueStorage: KeyValueStorageProtocol) {
        self.keyValueStorage = keyValueStorage
    }
    
    func follow(_ user: User) {
        keyValueStorage.set(value: true, forKey: String(user.id))
    }
}
