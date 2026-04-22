//
//  KeyValueStorage.swift
//  StackOverflowUsers
//
//  Created by Radek on 22.04.2026.
//

import Foundation

protocol KeyValueStorageProtocol {
    func set(value: Bool, forKey key: String)
    func value(forKey key: String) -> Bool?
}

class KeyValueStorage: KeyValueStorageProtocol {
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func set(value: Bool, forKey key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func value(forKey key: String) -> Bool? {
        userDefaults.value(forKey: key) as? Bool
    }
}
